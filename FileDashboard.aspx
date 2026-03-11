<%@ Page Title="Title" Language="C#" MasterPageFile="~/MenuPrincipal.Master" CodeBehind="FileDashboard.aspx.cs" Inherits="GestionDocumentos.FileDashboard" %>

<asp:Content ID="FileDashboardContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <div class="row">

            <aside class="col-md-3 col-lg-2 mb-4">
                <div class="d-grid gap-2 mb-4">
                    <asp:Button ID="BtnUpdateFile" runat="server" Text="Subir archivo"
                        CssClass="btn btn-primary shadow-sm rounded-pill fw-bold" />
                </div>

                <div class="list-group shadow-sm">
                    <a href="#" class="list-group-item list-group-item-action active">
                        <i class="bi bi-file-earmark-text me-2"></i>Mis archivos
                    </a>
                    <a href="#" class="list-group-item list-group-item-action">
                        <i class="bi bi-people me-2"></i>Compartidos
                    </a>
                </div>
            </aside>

            <section class="col-md-9 col-lg-10">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="fw-bold m-0">Mis archivos</h2>
                            <asp:Label ID="LblLoggedUserWelcome" runat="server" CssClass="badge bg-light text-dark p-2 border"></asp:Label>
                        </div>

                        <div class="row g-3 mb-4 bg-light p-3 rounded-3 border">

                            <div class="row g-3 mb-4 align-items-end bg-light p-3 rounded-3 border mx-0">
                                <div class="col-md-3">
                                    <label class="form-label small fw-bold text-muted">Tipo de Documento</label>
                                    <asp:DropDownList ID="ddlTipoDocumento" runat="server" CssClass="form-select shadow-sm">
                                        <asp:ListItem Value="0">-- Todos los tipos --</asp:ListItem>
                                        <asp:ListItem Value="1">PDF</asp:ListItem>
                                        <asp:ListItem Value="2">Excel</asp:ListItem>
                                        <asp:ListItem Value="3">Imagen</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-6">
                                    <label class="small text-muted mb-1">Ordenar por:</label>
                                    <asp:DropDownList ID="FilterOptions" runat="server" CssClass="form-select">
                                        <asp:ListItem Value="0">Por fecha ascendente</asp:ListItem>
                                        <asp:ListItem Value="1">Por fecha descendente</asp:ListItem>
                                        <asp:ListItem Value="2">Por nombre ascendente</asp:ListItem>
                                        <asp:ListItem Value="3">Por nombre descendente</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-6">
                                    <label class="small text-muted mb-1">Buscar documento:</label>
                                    <div class="input-group">
                                        <asp:TextBox ID="TxtSearchFile" runat="server" CssClass="form-control" placeholder="Nombre del archivo..."></asp:TextBox>
                                        <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                                    </div>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <asp:GridView ID="GridView1" runat="server"
                                    CssClass="table table-hover align-middle"
                                    GridLines="None"
                                    AutoGenerateColumns="true">
                                    <HeaderStyle CssClass="table-light text-muted small text-uppercase" />
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
            </section>

        </div>
    </div>
</asp:Content>
