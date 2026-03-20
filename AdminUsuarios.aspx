<%@ Page Title="Usuarios" Language="C#" MasterPageFile="~/MenuPrincipal.master" AutoEventWireup="true" CodeBehind="AdminUsuarios.aspx.cs" Inherits="GestionDocumentos.AdminUsuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <h1 class="text-center">Usuarios del sistema</h1>
        <div class="row">
            <div class="w-100 d-flex justify-content-start">
                <a class="btn btn-primary mb-3" href="AdminUsuarioForm.aspx">Crear usuario</a>
            </div>
            
            <div class="card shadow-sm border-0 rounded-3">
            <div class="card-body p-0 table-responsive">
            
            <asp:GridView ID="GvUsers" runat="server" 
                CssClass="table table-bordered table-striped table-hover align-middle mb-0" 
                GridLines="None" 
                AutoGenerateColumns="false" OnRowCommand="GvUsers_RowCommand">
                
                <HeaderStyle CssClass="bg-white text-dark fw-bold" />
                
                <Columns>    
                    <asp:BoundField DataField="Id" HeaderText="Id" ItemStyle-Width="60px" ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                    
                    <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre" />
                    
                    <asp:BoundField DataField="Email" HeaderText="Correo" />

                    <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="130px">
                        <ItemTemplate>
                            <div class="d-flex gap-2">
                                <asp:Button ID="BtnEdit" runat="server" 
                                                CommandName="EditUser" 
                                                CommandArgument='<%# Eval("Id") %>' 
                                                CssClass="btn btn-sm btn-light border shadow-sm text-warning"
                                                ToolTip="Editar usuario" Text="Editar" />
                                
                                <asp:Button ID="BtnDelete" runat="server" 
                                            CommandName="DeleteUser" 
                                            CommandArgument='<%# Eval("Id") %>' 
                                            CssClass="btn btn-sm btn-light border shadow-sm text-secondary"
                                            OnClientClick="return confirm('¿Estás seguro de que deseas eliminar este usuario?');"
                                            ToolTip="Eliminar usuario" Text="Eliminar"/> 
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            
        </div>
    </div>
        </div>
    </div>
</asp:Content>
