﻿using CharlieBackend.Business.Services.Interfaces;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Telegram.Bot;
using CharlieBackend.Business.Models.Commands;
using CharlieBackend.Data;

namespace CharlieBackend.Business.Models
{
    public class Bot
    {
        private static TelegramBotClient _client;
        private static List<Command> _commandsList;
        public string Name { get; }
        public static IReadOnlyCollection<Command> Commands { get => _commandsList.AsReadOnly(); }
        public static async Task<TelegramBotClient> Get(IServiceProvider services)
        {
            var startCommand = services.GetRequiredService<StartCommand>();
            var helloCommand = services.GetRequiredService<HelloCommand>();
            var getMarkCommand = services.GetRequiredService<GetMarkCommand>();
            
            _commandsList = new List<Command>();
            _commandsList.Add(startCommand);
            _commandsList.Add(helloCommand);
            _commandsList.Add(getMarkCommand);


            _client = new TelegramBotClient(AppSettings.Key);
            var hook = AppSettings.Url + "/api/bot/message/update";
            await _client.SetWebhookAsync(hook);

            return _client;
        }
    }
}