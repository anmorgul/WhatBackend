﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace CharlieBackend.Core.DTO.Course
{
    public class UpdateCourseDto
    {
        public long Id { get; set; } //TODO fix
        public string Name { get; set; }
    }
}
