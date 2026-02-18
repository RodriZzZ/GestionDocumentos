<%@ Page Title="" Language="C#" MasterPageFile="~/MenuPrincipal.master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="GestionDocumentos.Home" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-5">
        <div class="p-5 mb-4 bg-light rounded-3 shadow-sm">
            <div class="container-fluid py-5 text-center">
                <h1 class="display-5 fw-bold">Sistema de Gestión Documental</h1>
                <p class="col-md-12 fs-4 text-muted">Bienvenido al panel principal. Utiliza el menú superior para navegar entre las secciones del sistema.</p>
                <hr class="my-4" />
                <asp:Label ID="lblUserWelcome" runat="server" CssClass="h5 text-primary fw-bold"></asp:Label>
            </div>
        </div>
    </div>

</asp:Content>
