<%@ Page Language="C#"
    MasterPageFile="~/Admin.master"
    AutoEventWireup="true"
    CodeBehind="TestAdmin.aspx.cs"
    Inherits="SatisPaneli.TestAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container-fluid">
        <h1 class="mb-3">Dashboard</h1>

        <div class="row">

            <div class="col-md-3">
                <div class="small-box bg-info">
                    <div class="inner">
                        <h3>15</h3>
                        <p>Ürün</p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-box"></i>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="small-box bg-success">
                    <div class="inner">
                        <h3>8</h3>
                        <p>Satış</p>
                    </div>
                    <div class="icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                </div>
            </div>

        </div>
    </div>

</asp:Content>
