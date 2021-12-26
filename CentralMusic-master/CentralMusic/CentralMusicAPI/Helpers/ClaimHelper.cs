
using System.Security.Claims;

namespace CentralMusicAPI.Helpers
{
    public class ClaimHelper
    {

        /// <summary>
        /// Método para obter o id do utilizador através do token
        /// </summary>
        /// <param name="claimsIdentity"></param>
        /// <returns>Id do User</returns>
        public static int? GetIdFromClaimIdentity(ClaimsIdentity claimsIdentity)
        {
            foreach (var claim in claimsIdentity.Claims)
            {
                if (claim.Type.Equals(ClaimTypes.SerialNumber))
                {
                    return int.Parse(claim.Value);
                }
            }

            return null;
        }

        /// <summary>
        /// Método para obter o email do utilizador através do token
        /// </summary>
        /// <param name="claimsIdentity"></param>
        /// <returns>Email do User</returns>
        public static string GetEmailFromClaimIdentity(ClaimsIdentity claimsIdentity)
        {
            foreach (var claim in claimsIdentity.Claims)
            {
                if (claim.Type.Equals(ClaimTypes.Email))
                {
                    return claim.Value;
                }
            }

            return null;
        }
    }
}
