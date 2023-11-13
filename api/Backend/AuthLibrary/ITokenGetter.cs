using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AuthLibrary
{
    public interface ITokenGetter
    {
        public Task<string> GetUserToken();
        public Task<string> GetServerToken();
    }
}
