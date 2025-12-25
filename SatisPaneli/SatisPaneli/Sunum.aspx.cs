using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SatisPaneli
{
    public partial class Sunum : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Karakter kodlamasını UTF-8 olarak zorla
            Response.ContentEncoding = System.Text.Encoding.UTF8;
            Response.Charset = "utf-8";
        }
    }
}
