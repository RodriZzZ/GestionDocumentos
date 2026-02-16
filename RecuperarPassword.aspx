<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RecuperarPassword.aspx.cs" Inherits="GestionDocumentos.RecuperarPassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5 text-center">
        <div class="col-md-4 mx-auto">
            <h3>Recuperar Acceso</h3>
            <p>Escribe tu correo para enviarte un codigo</p>
            <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control mb-3" placeholder="correo@ejemplo.com" />

            <asp:RegularExpressionValidator ID="revCorreo" runat="server" ControlToValidate="txtCorreo"
                ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                ErrorMessage="Formato de correo invalido." ForeColor="Red" Display="Dynamic"/>

            <asp:Button ID="btnRecuperar" runat="server" Text="Enviar Correo" CssClass="btn btn-outline-primary w-100" />
        </div>
    </div>
</asp:Content>
