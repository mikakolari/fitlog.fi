﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crash.Fit.Api.Models.Users
{
    public class LoginRequest
    {
        public string Client { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
    }
}
