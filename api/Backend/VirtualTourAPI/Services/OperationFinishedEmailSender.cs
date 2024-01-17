using EmailLibrary;

namespace VirtualTourAPI.Services
{
    public class OperationFinishedEmailSender : EmailSender
    {
        private const string SUBJECT = "Twoja scena została wygenerowana!";
        private const string MESSAGE = """
                Szanowny użytkowniku,
                
                Z przyjemnością informujemy Cię, że scena '{0}' twojego wirtualnego spaceru '{1}' została wygenerowana. 
                Nie czekaj i wykoszystaj ją w swoim ogłoszeniu!


                Z poważaniem,
                Zespół CCQuarters
                """;

        private readonly string _tourName;
        private readonly string _sceneName;

        public OperationFinishedEmailSender(IConfiguration configuration, string tourName, string sceneName) 
            : base(configuration)
        {
            _tourName = tourName;
            _sceneName = sceneName;
        }

        public override async Task Send(string toEmail)
        {
            await SendEmailAsync(toEmail, SUBJECT, string.Format(MESSAGE, _sceneName, _tourName));
        }
    }
}
