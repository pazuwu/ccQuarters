using Azure.Communication.Email;
using Azure;
using Microsoft.Extensions.Configuration;

namespace EmailLibrary
{
    public interface IEmailSender
    {
        Task Send(string toEmail);
    }
}