using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.SpaServices.Webpack;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Crash.Fit.Nutrition;
using System.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Crash.Fit.Web.Models.Auth;
using Microsoft.AspNetCore.Authentication.Cookies;
using Crash.Fit.Training;
using Microsoft.AspNetCore.Http.Internal;
using Crash.Fit.Logging;
using Crash.Fit.Measurements;
using Crash.Fit.Profile;
using Crash.Fit.Api.Models.Feedback;
using Crash.Fit.Feedback;
using Crash.Fit.Api.Models.Training;
using Crash.Fit.Api.Models.Nutrition;
using Crash.Fit.Api.Models.Profile;
using Crash.Fit.Api.Models.Measurements;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authentication.Facebook;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Authentication.JwtBearer;

namespace Crash.Fit.Web
{
    public class Startup
    {
        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddEnvironmentVariables();
            Configuration = builder.Build();
        }

        public IConfigurationRoot Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddAuthentication(o => 
            {
                o.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                o.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddFacebook(o =>
            {
                o.AppId = Configuration["Authentication:Facebook:AppId"];
                o.AppSecret = Configuration["Authentication:Facebook:AppSecret"];
            }).AddGoogle(o =>
            {
                o.ClientId = Configuration["Authentication:Google:ClientId"];
                o.ClientSecret = Configuration["Authentication:Google:ClientSecret"];
            }).AddJwtBearer(o => 
            {
                /*
                  app.UseJwtBearerAuthentication(new JwtBearerOptions
                {
                    AutomaticAuthenticate = true,
                    AutomaticChallenge = true,
                    TokenValidationParameters = new TokenValidationParameters
                    {
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration.GetSection("Authentication:Jwt:Key").Value)),
                        ValidAudience = Configuration.GetSection("Authentication:Jwt:SiteUrl").Value,
                        ValidateIssuerSigningKey = true,
                        ValidateLifetime = true,
                        ValidIssuer = Configuration.GetSection("Authentication:Jwt:SiteUrl").Value
                    }
                });
            */
                o.Audience = Configuration.GetSection("Authentication:Jwt:SiteUrl").Value;
                //o.Authority = Configuration.GetSection("Authentication:Jwt:SiteUrl").Value;
                o.ClaimsIssuer = Configuration.GetSection("Authentication:Jwt:SiteUrl").Value;
                o.RequireHttpsMetadata = false;
                o.IncludeErrorDetails = true;
                o.SaveToken = true;
                o.TokenValidationParameters = new TokenValidationParameters
                {
                    //ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration.GetSection("Authentication:Jwt:Key").Value)),

                    //ValidateIssuer = true,
                    ValidIssuer = Configuration.GetSection("Authentication:Jwt:SiteUrl").Value,

                    //ValidateAudience = true,
                    ValidAudience = Configuration.GetSection("Authentication:Jwt:SiteUrl").Value,
                    
                    //ValidateLifetime = true,
                    //ClockSkew = TimeSpan.FromMinutes(1)
                };
            });
            services.AddDbContext<UserContext>(options =>
            {
                options.UseSqlServer(Configuration.GetConnectionString("Crash.Fit"));
            });

            services.AddIdentity<User, Role>()
                .AddEntityFrameworkStores<UserContext>()
                .AddDefaultTokenProviders();
            services.Configure<IdentityOptions>(options =>
            {
                options.User.RequireUniqueEmail = false;
                options.User.AllowedUserNameCharacters += "������";
                options.Password.RequireDigit = false;
                options.Password.RequireLowercase = false;
                options.Password.RequireNonAlphanumeric = false;
                options.Password.RequireUppercase = false;
                //options.Cookies.ApplicationCookie.CookieHttpOnly = false;
            });

            services.AddCors();
            services.AddAntiforgery(options => options.HeaderName = "X-CSRF-TOKEN");
            services.AddMvc();
            


            services.AddTransient<INutritionRepository>(s => 
            {
                return new NutritionRepository(SqlClientFactory.Instance, Configuration.GetConnectionString("Crash.Fit"));
            });
            services.AddTransient<ITrainingRepository>(s =>
            {
                return new TrainingRepository(SqlClientFactory.Instance, Configuration.GetConnectionString("Crash.Fit"));
            });
            services.AddTransient<IMeasurementRepository>(s =>
            {
                return new MeasurementRepository(SqlClientFactory.Instance, Configuration.GetConnectionString("Crash.Fit"));
            });
            services.AddTransient<IProfileRepository>(s =>
            {
                return new ProfileRepository(SqlClientFactory.Instance, Configuration.GetConnectionString("Crash.Fit"));
            });
            services.AddTransient<ILogRepository>(s =>
            {
                return new LogRepository(SqlClientFactory.Instance, Configuration.GetConnectionString("Crash.Fit"));
            });
            services.AddTransient<IFeedbackRepository>(s =>
            {
                return new FeedbackRepository(SqlClientFactory.Instance, Configuration.GetConnectionString("Crash.Fit"));
            });
            services.AddSingleton<IConfigurationRoot>(Configuration);
            AutoMapper.Mapper.Initialize(m => {

                // Nutrients
                m.CreateMap<Nutrient, NutrientResponse>().AfterMap((model, response) =>
                {
                    response.HideSummary = model.DefaultHideSummary;
                    response.HideDetails = model.DefaultHideDetails;
                });
                /*
                m.CreateMap<UserNutrient, NutrientResponse>().AfterMap((model, response) => 
                {
                    response.HideSummary = model.UserHideSummary ?? model.DefaultHideSummary;
                    response.HideDetails = model.UserHideDetails ?? model.DefaultHideDetails;
                });
                */
                m.CreateMap<NutrientSetting, NutrientSettingResponse>();
                m.CreateMap<NutrientSettingRequest, NutrientSetting>().AfterMap((request, model) => 
                {
                    model.HideDetails = request.UserHideDetails;
                    model.HideSummary = request.UserHideSummary;
                });
                m.CreateMap<IEnumerable<NutrientAmount>, Dictionary<Guid, decimal>>().ConvertUsing(na => na.ToDictionary(n => n.NutrientId, n => n.Amount));
                m.CreateMap<NutrientAmount, NutrientAmountModel>();
                m.CreateMap<NutrientAmountModel, NutrientAmount>();

                m.CreateMap<NutritionGoalDetails, NutritionGoalResponse>();
                m.CreateMap<NutritionGoalPeriod, NutritionGoalPeriodResponse>();
                m.CreateMap<NutritionGoalValue, NutritionGoalPeriodResponse.NutrientValue>();

                m.CreateMap<NutritionGoalRequest, NutritionGoalDetails>();
                m.CreateMap<NutritionGoalPeriodRequest, NutritionGoalPeriod>();
                m.CreateMap<NutritionGoalPeriodRequest.NutrientValue, NutritionGoalValue>();
                // Foods
                m.CreateMap<FoodSearchResult, FoodSearchResultResponse>();
                m.CreateMap<FoodSummary, FoodSummaryResponse>();
                m.CreateMap<FoodDetails, FoodDetailsResponse>();
                m.CreateMap<FoodNutrientAmount, FoodNutrientAmountResponse>();
                m.CreateMap<NutrientAmountModel, FoodNutrientAmount>();
                m.CreateMap<FoodRequest, FoodDetails>();

                // Meals
                m.CreateMap<MealDetails, MealDetailsResponse>();
                m.CreateMap<MealRow, MealRowModel>();
                m.CreateMap<MealRequest, MealDetails>().ForMember(d => d.Time, x => { x.Ignore(); }).AfterMap((source, target) =>
                {
                    int hour = 0;
                    int minute = 0;
                    var timeParts = (source.Time ?? "").Replace('.', ':').Split(':');
                    if (timeParts.Length > 0)
                    {
                        int.TryParse(timeParts[0], out hour);
                    }
                    if (timeParts.Length > 1)
                    {
                        int.TryParse(timeParts[1], out minute);
                    }
                    var date = DateTimeUtils.ToLocal(source.Date);
                    var time = new DateTime(date.Year, date.Month, date.Day, hour, minute, 0);

                    target.Time = new DateTimeOffset(time, DateTimeUtils.GetTimeZoneOffset(time));
                });
                m.CreateMap<MealRowModel, MealRow>();

                // Meal rhythm
                m.CreateMap<MealDefinition, MealDefinitionResponse>().AfterMap((model, response) => 
                {
                    if (model.Start.HasValue)
                    {
                        response.StartHour = model.Start.Value.Hours;
                        response.StartMinute = model.Start.Value.Minutes;
                    }
                    if (model.End.HasValue)
                    {
                        response.EndHour = model.End.Value.Hours;
                        response.EndMinute = model.End.Value.Minutes;
                    }
                });
                // Recipes
                m.CreateMap<FoodSummary, RecipeSummaryResponse>();
                m.CreateMap<FoodDetails, RecipeDetailsResponse>();
                m.CreateMap<RecipeIngredient, RecipeIngredientModel>();
                m.CreateMap<RecipeRequest, FoodDetails>();
                m.CreateMap<RecipeIngredientModel, RecipeIngredient>();

                // Portions
                m.CreateMap<Portion, PortionResponse>();
                m.CreateMap<PortionRequest, Portion>();

                // Workouts
                m.CreateMap<WorkoutSummary, WorkoutSummaryResponse>();
                m.CreateMap<WorkoutDetails, WorkoutDetailsResponse>();
                m.CreateMap<WorkoutSet, WorkoutSetResponse>();
                m.CreateMap<WorkoutRequest, WorkoutDetails>().AfterMap((request, model) => 
                {
                    model.Time = DateTimeUtils.ToLocal(model.Time);
                });
                m.CreateMap<WorkoutSetRequest, WorkoutSet>();

                // Exercises
                m.CreateMap<Exercise, ExerciseResponse>();
                m.CreateMap<ExerciseDetails, ExerciseDetailsResponse>();
                m.CreateMap<ExerciseSummary, ExerciseSummaryResponse>();
                m.CreateMap<ExerciseRequest, ExerciseDetails>();

                // Routines
                m.CreateMap<RoutineSummary, RoutineResponse>();
                m.CreateMap<RoutineDetails, RoutineDetailsResponse>();
                m.CreateMap<RoutineWorkout, RoutineWorkoutResponse>();
                m.CreateMap<RoutineExercise, RoutineExerciseResponse>();
                m.CreateMap<RoutineRequest, RoutineDetails>();
                m.CreateMap<RoutineWorkoutRequest, RoutineWorkout>();
                m.CreateMap<RoutineExerciseRequest, RoutineExercise>();

                // MuscleGroups
                m.CreateMap<MuscleGroup, MuscleGroupResponse>();

                // Training goals
                m.CreateMap<TrainingGoalDetails, TrainingGoalResponse>();
                m.CreateMap<TrainingGoalExercise, TrainingGoalExerciseResponse>();
                m.CreateMap<TrainingGoalRequest, TrainingGoalDetails>();
                m.CreateMap<TrainingGoalExerciseRequest, TrainingGoalExercise>();

                // Measurements
                m.CreateMap<MeasureSummary, MeasureSummaryResponse>();

                // Profile
                m.CreateMap<Profile.Profile, ProfileResponse>();

                // Feedback
                m.CreateMap<FeedbackSummary, FeedbackSummaryResponse>();
                m.CreateMap<FeedbackDetails, FeedbackDetailsResponse>();
                m.CreateMap<FeedbackComment, FeedbackDetailsResponse.Comment>();
                m.CreateMap<FeedbackRequest, FeedbackDetails>();
            });

            
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory)
        {
            loggerFactory.AddConsole(Configuration.GetSection("Logging"));
            loggerFactory.AddDebug();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseWebpackDevMiddleware(new WebpackDevMiddlewareOptions {
                    HotModuleReplacement = true
                });
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
            }

            app.UseStaticFiles();

            app.UseCors(p => p.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());

            app.UseAuthentication();

            app.Use(async (context, next) =>
            {
                context.Request.EnableRewind();
                // Do work that doesn't write to the Response.
                await next.Invoke();
                // Do logging or other work that doesn't write to the Response.
            });
            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller=Home}/{action=Index}/{id?}");

                routes.MapSpaFallbackRoute(
                    name: "spa-fallback",
                    defaults: new { controller = "Home", action = "Index" });
            });
            
        }
    }
}
