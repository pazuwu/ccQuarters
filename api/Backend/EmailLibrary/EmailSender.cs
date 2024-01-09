using Azure.Communication.Email;
using Azure;
using Microsoft.Extensions.Configuration;

namespace EmailLibrary
{
    public abstract class EmailSender : IEmailSender
    {
        private readonly string connectionString = "";
        private readonly string credentialKey = "";
        private readonly string emailFrom = "";

        public EmailSender(IConfiguration configuration)
        {
            connectionString = (configuration["Email:EmailService"]
                ?? Environment.GetEnvironmentVariable("APPSETTING_EMAIL_SERVICE")) 
                ?? "";
            credentialKey = configuration["Email:ServiceKey"] ?? "";
            emailFrom = configuration["Email:DoNotReplyEmail"] ?? "";

        }

        public abstract Task Send(string toEmail);

        protected async Task SendEmailAsync(string toEmail, string subject, string message)
        {
            var client = new EmailClient(new Uri(connectionString), new AzureKeyCredential(credentialKey));
            var content = new EmailContent(subject)
            {
                PlainText = message,
            };
            var msg = new EmailMessage(emailFrom, toEmail, content);
            await client.SendAsync(WaitUntil.Started, msg);
        }
    }
}