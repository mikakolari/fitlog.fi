﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Crash.Fit.Training
{
    public interface ITrainingRepository
    {
        IEnumerable<MuscleGroup> GetMuscleGroups();

        IEnumerable<Exercise> SearchExercises(string[] nameTokens, Guid? userId);
        IEnumerable<ExerciseDetails> SearchUserExercises(Guid userId, DateTimeOffset start1RM);
        ExerciseDetails GetExercise(Guid id);
        IEnumerable<ExerciseDetails> GetExercises(IEnumerable<Guid> ids);
        void CreateExercise(ExerciseDetails exercise);
        void UpdateExercise(ExerciseDetails exercise);
        void DeleteExercise(Exercise exercise);
        void RestoreExercise(Guid id, out ExerciseDetails exercise);

        IEnumerable<WorkoutDetails> SearchWorkouts(Guid userId, DateTimeOffset start, DateTimeOffset end);
        IEnumerable<Activity> GetActivities();
        WorkoutDetails GetWorkout(Guid id);
        void CreateWorkout(WorkoutDetails workout);
        void UpdateWorkout(WorkoutDetails workout);
        void DeleteWorkout(Workout workout);
        void RestoreWorkout(Guid id, out WorkoutDetails workout);

        IEnumerable<RoutineSummary> SearchRoutines(Guid userId);
        RoutineDetails GetRoutine(Guid id);
        void CreateRoutine(RoutineDetails routine);
        void UpdateRoutine(RoutineDetails routine);
        void DeleteRoutine(Routine routine);
        void RestoreRoutine(Guid id, out RoutineDetails routine);
        Activity GetActivity(Guid id);
        void ActivateRoutine(Guid userId, Guid routineId);
        IEnumerable<TrainingGoalDetails> GetTrainingGoals(Guid userId);
        TrainingGoalDetails GetTrainingGoal(Guid id);
        void CreateTrainingGoal(TrainingGoalDetails goal);
        void UpdateTrainingGoal(TrainingGoalDetails goal);
        void ActivateTrainingGoal(TrainingGoal goal);
        void DeleteTrainingGoal(TrainingGoal goal);
        void CreateActivity(Activity activity);
        void SaveOneRepMaxs(IEnumerable<OneRepMax> maxs);
        IEnumerable<OneRepMax> GetOneRepMaxs(Guid userId, DateTimeOffset start);
        void UpdateActivity(Activity activity);
        void DeleteActivity(Activity activity);
        IEnumerable<EnergyExpenditure> GetEnergyExpenditures(Guid userId, DateTimeOffset start, DateTimeOffset dateTimeOffset);
        void CreateEnergyExpenditure(EnergyExpenditure expenditure);
        EnergyExpenditure GetEnergyExpenditure(Guid id);
        void UpdateEnergyExpenditure(EnergyExpenditure expenditure);
        void DeleteEnergyExpenditure(EnergyExpenditure expenditure);
        EnergyExpenditure GetEnergyExpenditureForWorkout(Guid workoutId);
    }
}
