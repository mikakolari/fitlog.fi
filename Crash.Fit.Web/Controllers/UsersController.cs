﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Logging;
using Crash.Fit.Api.Models.Users;
using Crash.Fit.Web.Models.Auth;
using Microsoft.AspNetCore.Antiforgery;
using Crash.Fit.Logging;
using Crash.Fit.Profile;
using Crash.Fit.Api.Models.Profile;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.Extensions.Configuration;

namespace Crash.Fit.Web.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    public class UsersController : ApiControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly SignInManager<User> _signInManager;
        private readonly IProfileRepository _profileRepository;
        private readonly IConfigurationRoot _configuration;

        public UsersController(UserManager<User> userManager,SignInManager<User> signInManager, IProfileRepository profileRepository, ILogRepository logger, IConfigurationRoot configuration) : base(logger)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _profileRepository = profileRepository;
            _configuration = configuration;
        }

        [HttpGet("me")]
        public IActionResult GetProfile()
        {
            var profile = _profileRepository.GetProfile(CurrentUserId);
            if(profile == null)
            {
                profile = new Profile.Profile
                {
                    UserId = CurrentUserId
                };
            }
            var result = AutoMapper.Mapper.Map<ProfileResponse>(profile);

            return Ok(result);
        }
        [HttpPut("me")]
        public IActionResult SaveProfile([FromBody]ProfileRequest model)
        {
            var profile = _profileRepository.GetProfile(CurrentUserId);
            if (profile == null)
            {
                profile = new Profile.Profile
                {
                    UserId = CurrentUserId
                };
            }
            profile.DoB = model.DoB;
            profile.Gender = model.Gender;
            profile.Height = model.Height;
            profile.Rmr = model.Rmr;
            profile.Weight = model.Weight;

            _profileRepository.SaveProfile(profile);
            var result = AutoMapper.Mapper.Map<ProfileResponse>(profile);

            return Ok(result);
        }
        [HttpPost("login")]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login([FromBody]LoginRequest model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest();
            }
            var user = await _userManager.FindByNameAsync(model.Username);
            if(user == null)
            {
                return BadRequest();
            }

            var result = await _signInManager.CheckPasswordSignInAsync(user, model.Password, false);
            if (!result.Succeeded || result.IsLockedOut)
            {
                return BadRequest();
            }

            return await TokenResult(user.Id);
        }

        [HttpPost("register")]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Register([FromBody]RegisterRequest model)
        {
            if(!ModelState.IsValid)
            {
                return BadRequest();
            }

            var user = new User { UserName = model.Email, Email = model.Email };
            var result = await _userManager.CreateAsync(user, model.Password);
            if (!result.Succeeded)
            {
                return BadRequest(new { ErrorCodes = result.Errors.Select(e => e.Code) });
            }

            return await TokenResult(user.Id);
        }

        [HttpPost("logout")]
        //[ValidateAntiForgeryToken]
        public async Task<IActionResult> LogOff()
        {
            await _signInManager.SignOutAsync();
            return RedirectToLocal("/");
        }


        [HttpGet("external-login")]
        [AllowAnonymous]
        //[ValidateAntiForgeryToken]
        public IActionResult ExternalLogin(string provider, string returnUrl = null, string client = null)
        {
            var redirectUrl = Url.Action("ExternalLoginCallback", "Users", new { ReturnUrl = returnUrl, Client = client ?? Api.ApiClient.Web });
            var properties = _signInManager.ConfigureExternalAuthenticationProperties(provider, redirectUrl);
            return Challenge(properties, provider);
        }

        [HttpGet("external-login-callback")]
        [AllowAnonymous]
        public async Task<IActionResult> ExternalLoginCallback(string client, string returnUrl = null, string remoteError = null)
        {
            if (remoteError != null)
            {
                ModelState.AddModelError(string.Empty, $"Error from external provider: {remoteError}");
                return View(nameof(Login));
            }
            var info = await _signInManager.GetExternalLoginInfoAsync();
            if (info == null)
            {
                return RedirectToAction(nameof(Login));
            }
            var user = await _userManager.FindByLoginAsync(info.LoginProvider, info.ProviderKey);
            if(user == null)
            {
                var email = info.Principal.FindFirstValue(ClaimTypes.Email);
                user = new User { Email = email, UserName = info.LoginProvider + "_" + info.ProviderKey };
                var creationResult = await _userManager.CreateAsync(user);
                if (!creationResult.Succeeded)
                {
                }
                creationResult = await _userManager.AddLoginAsync(user, info);
                if (!creationResult.Succeeded)
                {
                }
            }

            var refreshToken = _profileRepository.GetRefreshToken(user.Id);
            if (string.IsNullOrWhiteSpace(refreshToken))
            {
                refreshToken = _profileRepository.UpdateRefreshToken(user.Id);
            }
            var jwtToken = await GetJwtSecurityToken(user.Id);
            var accessToken = new JwtSecurityTokenHandler().WriteToken(jwtToken);

            return RedirectToLocal("/#/login-success/" + client + "/" + refreshToken + "/" + accessToken);
        }
        [HttpGet("refresh-token")]
        [AllowAnonymous]
        public async Task<IActionResult> RefreshAccessToken(string refreshToken)
        {
            var userId = _profileRepository.GetUserIdByRefreshToken(refreshToken);
            if (!userId.HasValue)
            {
                return Unauthorized();
            }

            return await TokenResult(userId.Value);
        }

        private async Task<IActionResult> TokenResult(Guid userId)
        {
            var refreshToken = _profileRepository.GetRefreshToken(userId);
            if (string.IsNullOrWhiteSpace(refreshToken))
            {
                refreshToken = _profileRepository.UpdateRefreshToken(userId);
            }
            var jwtToken = await GetJwtSecurityToken(userId);
            var accessToken = new JwtSecurityTokenHandler().WriteToken(jwtToken);


            return Ok(new TokenResponse
            {
                RefreshToken = refreshToken,
                Expires = jwtToken.ValidTo,
                AccessToken = accessToken
            });
        }

        private async Task<JwtSecurityToken> GetJwtSecurityToken(Guid userId)
        {
            var claims = new[] 
            {
                new Claim(ClaimTypes.NameIdentifier, userId.ToString())
            };
            return new JwtSecurityToken(
                issuer: _configuration.GetSection("Authentication:Jwt:SiteUrl").Value,
                audience: _configuration.GetSection("Authentication:Jwt:SiteUrl").Value,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(10),
                signingCredentials: new SigningCredentials(new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration.GetSection("Authentication:Jwt:Key").Value)), SecurityAlgorithms.HmacSha256)
            );
        }
   
        private IActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            else
            {
                return RedirectToAction(nameof(HomeController.Index), "Home");
            }
        }
    }
}
