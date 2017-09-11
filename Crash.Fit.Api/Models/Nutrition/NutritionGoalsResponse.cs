﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crash.Fit.Api.Models.Nutrition
{
    public class NutritionGoalsResponse
    {
        public bool Monday { get; set; }
        public bool Tuesday { get; set; }
        public bool Wednesday { get; set; }
        public bool Thursday { get; set; }
        public bool Friday { get; set; }
        public bool Saturday { get; set; }
        public bool Sunday { get; set; }
        public bool ExerciseDay { get; set; }
        public bool RestDay { get; set; }
        public MealDefinition[] Definitions { get; set; }
        public NutrientValue[] NutrientValues { get; set; }

        public class MealDefinition
        {
            public Guid Id { get; set; }
            public string Name { get; set; }
        }
        public class NutrientValue
        {
            public Guid NutrientId { get; set; }
            public decimal? Min { get; set; }
            public decimal? Max { get; set; }
        }
    }
}