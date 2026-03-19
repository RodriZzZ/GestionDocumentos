<%@ Page Title="" Language="C#" MasterPageFile="~/MenuPrincipal.master" AutoEventWireup="true" CodeBehind="AdminUsuarioForm.aspx.cs" Inherits="GestionDocumentos.AdminUsuarioForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-body p-4 p-md-5">
                    
                    <asp:Label CssClass="text-center mb-4 fw-bold text-primary" ID="LblTitle" runat="server">Crear nuevo usuario</asp:Label>

                    <div class="mb-3">
                        <asp:Label runat="server" ID="LblUserFirstName" Text="Nombres" CssClass="form-label small fw-bold text-muted" />
                        <asp:TextBox runat="server" ID="TxtUserFirstName" CssClass="form-control shadow-sm" placeholder="Ej. Juan Carlos" />
                        
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="TxtUserFirstName" 
                            ErrorMessage="* El nombre es obligatorio." CssClass="text-danger small mt-1" 
                            Display="Dynamic" ValidationGroup="UserInfo" />
                        
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="TxtUserFirstName" 
                            ValidationExpression="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$" 
                            ErrorMessage="* Solo se permiten letras, sin números ni símbolos." 
                            CssClass="text-danger small mt-1" Display="Dynamic" ValidationGroup="UserInfo" />
                    </div>
                    
                    <div class="mb-3">
                        <asp:Label runat="server" ID="LblUserLastName" Text="Apellidos" CssClass="form-label small fw-bold text-muted" />
                        <asp:TextBox runat="server" ID="TxtUserLastName" CssClass="form-control shadow-sm" placeholder="Ej. Pérez" />
                        
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="TxtUserLastName" 
                            ErrorMessage="* El apellido es obligatorio." CssClass="text-danger small mt-1" 
                            Display="Dynamic" ValidationGroup="UserInfo" />
                            
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="TxtUserLastName" 
                            ValidationExpression="^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$" 
                            ErrorMessage="* Solo se permiten letras, sin números ni símbolos." 
                            CssClass="text-danger small mt-1" Display="Dynamic" ValidationGroup="UserInfo" />
                    </div>

                    <div class="mb-3">
                        <asp:Label runat="server" ID="LblUserEmail" Text="Correo Electrónico" CssClass="form-label small fw-bold text-muted" />
                        <asp:TextBox runat="server" ID="TxtUserEmail" TextMode="Email" CssClass="form-control shadow-sm" placeholder="correo@ejemplo.com" />
                        
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="TxtUserEmail" 
                            ErrorMessage="* El correo es obligatorio." CssClass="text-danger small mt-1" 
                            Display="Dynamic" ValidationGroup="UserInfo" />
                            
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="TxtUserEmail" 
                            ValidationExpression="^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$" 
                            ErrorMessage="* Ingresa un correo electrónico válido." 
                            CssClass="text-danger small mt-1" Display="Dynamic" ValidationGroup="UserInfo" />
                    </div>
                    
                    <div class="mb-4">
                        <asp:Label runat="server" ID="LblPassword" Text="Contraseña" CssClass="form-label small fw-bold text-muted" />
                        <asp:TextBox runat="server" ID="TxtPassword" TextMode="Password" CssClass="form-control shadow-sm" placeholder="••••••••" />
                        
                        <asp:RequiredFieldValidator ID="ReqPassword" runat="server" ControlToValidate="TxtPassword" 
                            ErrorMessage="* La contraseña es obligatoria." CssClass="text-danger small mt-1" 
                            Display="Dynamic" ValidationGroup="UserInfo" />
                            
                        <asp:RegularExpressionValidator runat="server" ControlToValidate="TxtPassword" 
                            ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$" 
                            ErrorMessage="* Debe tener al menos 6 caracteres, una mayúscula, una minúscula y un número." 
                            CssClass="text-danger small mt-1" Display="Dynamic" ValidationGroup="UserInfo" />
                    </div>

                    <div class="mb-4">
                        <asp:Label runat="server" ID="LblRole" Text="Rol del usuario" CssClass="form-label small fw-bold text-muted" />
                        <asp:DropDownList runat="server" ID="DdlRole" CssClass="form-select shadow-sm" />

                        <asp:RequiredFieldValidator runat="server" ControlToValidate="DdlRole" InitialValue="0"
                            ErrorMessage="* Debes seleccionar un rol válido." CssClass="text-danger small mt-1" 
                            Display="Dynamic" ValidationGroup="UserInfo" />
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                        <a href="AdminUsuarios.aspx" class="btn btn-light rounded-pill px-4 shadow-sm border">Cancelar</a>
                        
                        <asp:Button runat="server" ID="BtnUpsertUser" Text="Guardar Usuario" 
                            CssClass="btn btn-primary rounded-pill px-4 shadow-sm fw-bold" 
                            ValidationGroup="UserInfo" OnClick="BtnUpsertUser_Click"/>
                        <asp:Label ID="LblError" CssClass="text-danger small mt-1" runat="server" />
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>
</asp:Content>
