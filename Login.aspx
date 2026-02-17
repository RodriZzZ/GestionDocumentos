<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="GestionDocumentos.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .split-container {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            border-radius: 20px;
            overflow: hidden;
            border: none;
        }
        .left-panel {
            background: linear-gradient(135deg, #0052D4, #4364F7, #6FB1FC);
            color: white;
            padding: 4rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .right-panel {
            background: white;
            padding: 4rem;
        }
        .input-pill {
            border-radius: 50px !important;
            padding: 12px 20px;
            background-color: #f8f9fa;
        }
        .btn-login {
            border-radius: 50px;
            padding: 12px;
            background-color: #007bff;
            font-weight: bold;
        }
    </style>

    <div class="container split-container">
        <div class="row login-card shadow-lg w-100">
            <div class="col-lg-7 d-none d-lg-flex left-panel">
                <h1 class="display-4 fw-bold">Gestión de Documentos</h1>
                <p class="lead">Sistema Institucional de Gestión de Documentos y Control de Versiones.</p>
                <div class="mt-4">
                    <button type="button" class="btn btn-outline-light rounded-pill px-4">Leer más</button>
                </div>
            </div>

            <div class="col-lg-5 right-panel">
                <div class="text-center mb-5">
                    <h2 class="fw-bold">¡Hola de nuevo!</h2>
                    <p class="text-muted">Bienvenido de vuelta</p>
                </div>

                <div class="mb-4">
                    <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control input-pill" placeholder="Correo Electrónico"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUsuario" 
                        ErrorMessage="El usuario es obligatorio." ForeColor="Red" Display="Dynamic" CssClass="small ms-3" />
                </div>

                <div class="mb-4">
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control input-pill" TextMode="Password" placeholder="Contraseña"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" 
                        ErrorMessage="La contraseña es obligatoria." ForeColor="Red" Display="Dynamic" CssClass="small ms-3" />
                </div>

                <div class="d-grid gap-2 mb-4">
                    <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión" CssClass="btn btn-primary btn-login" OnClick="btnLogin_Click" />
                </div>

                <div class="text-center">
                    <a href="RecuperarPassword.aspx" class="text-decoration-none text-muted small">¿Olvidaste tu contraseña?</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
