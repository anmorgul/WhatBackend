﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using CharlieBackend.Core;
using System.Threading;
using Microsoft.AspNetCore.Authorization;
using CharlieBackend.Business.Services.Interfaces;
using System.IO;

namespace CharlieBackend.Api.Controllers
{
    /// <summary>
    /// Controller to manupulate with attachments
    /// </summary>
    [Route("api/attachments")]
    [ApiController]
    public class AttachmentsController : ControllerBase
    {

        private readonly IAttachmentService _attachmentService;

        /// <summary>
        /// Attachments controller constructor
        /// </summary>
        public AttachmentsController(IAttachmentService attachmentService)
        {
            _attachmentService = attachmentService;
        }

        /// <summary>
        /// POST api/attachments
        /// </summary>
        /// <response code="200">Successful attachment</response>
        [Authorize(Roles = "Admin, Secretary, Mentor, Student")]
        [HttpPost]
        public async Task<IActionResult> PostAttachments([FromForm] IFormFileCollection fileCollection)
        {
            var addedAttachments = await _attachmentService.AddAttachmentsAsync(fileCollection);

            return addedAttachments.ToActionResult();
        }

        /// <summary>
        /// GET: api/attachments
        /// </summary>
        [Authorize(Roles = "Admin, Secretary, Mentor, Student")]
        [HttpGet]
        public async Task<IActionResult> GetAttachments()
        {
            var attachments = await _attachmentService.GetAttachmentsListAsync();

            return attachments.ToActionResult();
        }

        /// </summary>
        /// GET: api/attachments/{id}
        /// </summary>
        [Authorize(Roles = "Admin, Secretary, Mentor, Student")]
        [HttpGet("{attachmentId}")]
        public async Task<IActionResult> GetAttachment(long attachmentId)
        {
            var attachment = await _attachmentService.DownloadAttachmentAsync(attachmentId);

            return File
                (
                attachment.Data.downloadInfo.Content, 
                attachment.Data.downloadInfo.ContentType, 
                attachment.Data.fileName 
                );
        }

        /*
        // PUT api/<AttachmentsController>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<AttachmentsController>/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
         */
    }
}
