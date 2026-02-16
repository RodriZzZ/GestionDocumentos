<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="GestionDocumentos.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card shadow-lg border-0">
                    <div class="card-body p-5">
                        <h3 class="text-center mb-4">Iniciar Sesión</h3>

                        <div class="mb-3">
                            <asp:Label runat="server" Text="Usuario" CssClass="form-label" />
                            <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control" placeholder="Ej. Rodrigo2026" />
                            <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUsuario"
                                ErrorMessage="El usuario es obligatorio" ForeColor="Red" Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <asp:Label runat="server" Text="Contraseña" CssClass="form-label" />
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" />
                            <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPassword" 
                                ErrorMessage="La clave es obligatoria" ForeColor="Red" Display="Dynamic" />
                        </div>

                        <div class="d-grid gap-2 mb-3">
                            <asp:Button ID="btnLogin" runat="server" Text="Ingresar" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
                        </div>

                        <div class="text-center">
                            <a href="RecuperacionPassword.aspx" class="text-decoration-none">¿Olvidaste tu contraseña?</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
