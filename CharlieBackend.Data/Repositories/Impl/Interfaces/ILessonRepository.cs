﻿using System.Threading.Tasks;
using System.Collections.Generic;
using CharlieBackend.Core.Entities;
using CharlieBackend.Core.DTO.Lesson;

namespace CharlieBackend.Data.Repositories.Impl.Interfaces
{
    public interface ILessonRepository : IRepository<Lesson>
    {
        public Task<IList<StudentLessonDto>> GetStudentInfoAsync(long studentId);

        Task<List<Lesson>> GetLessonsForMentorAsync(long? studentGroupId, System.DateTime? startDate, System.DateTime? finishDate, long mentorId);

        Task<List<Lesson>> GetAllLessonsForMentor(long mentorId);
    }
}
