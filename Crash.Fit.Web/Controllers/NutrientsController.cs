using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Crash.Fit.Nutrition;

namespace Crash.Fit.Web.Controllers
{
    [Produces("application/json")]
    [Route("api/[controller]")]
    public class NutrientsController : Controller
    {
        private readonly INutritionRepository nutritionRepository;
        public NutrientsController(INutritionRepository nutritionRepository)
        {
            this.nutritionRepository = nutritionRepository;
        }
        [HttpGet]
        [Route("")]
        public IEnumerable<Nutrient> List()
        {
            return nutritionRepository.GetNutrients();
        }
        [HttpGet]
        [Route("daily-intakes")]
        public IEnumerable<DailyIntake> DailyIntakes(Gender gender, DateTime dateOfBirth)
        {
            var age = DateTime.Now - dateOfBirth;
            return nutritionRepository.GetDailyIntakes(gender, age);
        }
    }
}