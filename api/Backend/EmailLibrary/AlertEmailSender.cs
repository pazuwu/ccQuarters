using Microsoft.Extensions.Configuration;

namespace EmailLibrary
{
    public class AlertEmailSender : EmailSender
    {
        private const string SUBJECT = "Znaleźliśmy mieszkanie spełniające Twoje kryteria!";
        private const string MESSAGE = "Szanowny użytkowniku,\n\nZ przyjemnością informujemy Cię, że znaleźliśmy mieszkanie, które odpowiada Twoim wyszukiwanym kryteriom. Kliknij poniższy link, aby zobaczyć szczegóły ogłoszenia:\n\n{0}\n\nDziękujemy, że korzystasz z naszej aplikacji. Życzymy udanych poszukiwań i mamy nadzieję, że to mieszkanie spełni Twoje oczekiwania.\n\nZ poważaniem,\nZespół CCQuarters";
        
        private readonly string _houseUrl;

        public AlertEmailSender(IConfiguration configuration, string houseId) : base(configuration)
        {
            var siteUrl = configuration["Email:SiteUrl"];
            if(string.IsNullOrEmpty(siteUrl))
                throw new ArgumentNullException(nameof(siteUrl));
            if (string.IsNullOrEmpty(houseId))
                throw new ArgumentNullException(nameof(houseId));

            _houseUrl = $"{siteUrl}/houses/{houseId}";
        }

        public override async Task Send(string toEmail)
        {
            await SendEmailAsync(toEmail, SUBJECT, string.Format(MESSAGE, _houseUrl));
        }
    }
}
