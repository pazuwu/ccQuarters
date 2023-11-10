using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace AuthLibrary
{
    public static class TokenGettersExtensions
    {
        public static string? GetUserId(this ClaimsIdentity identity)
        {
            return identity.FindFirst("user_id")?.Value;
        }
    }
}
