using System.Net.Mail;

namespace CentralMusicAPI.Helpers
{
    public class PasswordLost
    {
        /// <summary>
        /// Método para realizar o pedido de uma nova passowrd
        /// </summary>
        /// <param name="emailToSend">Endereço Email</param>
        /// <param name="tokenString">Token</param>
        public static void NewPasswordRequest(string emailToSend, string tokenString)
        {
            System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();

            mail.To.Add(emailToSend);
            mail.From = new MailAddress("no.reply.centralmusic@gmail.com");
            mail.Subject = "Recuperação de Password - CentralMusic";
            mail.SubjectEncoding = System.Text.Encoding.UTF8;
            mail.Body = "Aqui está o token para recuperação de password. <br />\r\n"
                        + "Continua com os passos na sua aplicação para a recuperação da password. <br />" + "\r\n" + "<br>"
                        + "Token: <b>" + tokenString + "</b>\r\n <br />" + "<br>"
                        + "Se não pediu alguma alteração de palavra passe, por favor ignore este e-mail!";
            mail.BodyEncoding = System.Text.Encoding.UTF8;
            mail.IsBodyHtml = true;
            mail.Priority = MailPriority.High;
            SmtpClient client = new SmtpClient();

            client.Credentials = new System.Net.NetworkCredential("no.reply.centralmusic@gmail.com", "centralmusicLDS");
            client.Port = 587;
            client.Host = "smtp.gmail.com";
            client.EnableSsl = true;

            client.Send(mail);
        }
    }
}
