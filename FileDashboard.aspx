<%@ Page Title="Title" Language="C#" MasterPageFile="~/MenuPrincipal.Master" CodeBehind="FileDashboard.aspx.cs" Inherits="GestionDocumentos.FileDashboard" %>

<asp:Content ID="FileDashboardContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid">
        <div class="row">
            <aside class="col-md-3 col-lg-2 mb-4">
                <div class="d-grid gap-2 mb-4">
                    <button type="button" class="btn btn-outline-primary shadow-sm rounded-pill fw-bold" data-bs-toggle="modal" data-bs-target="#modalUploadFile">
                        Subir archivo
                    </button>
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
                                    <asp:Label class="small text-muted mb-1" ID="LblTxtSearchFile" runat="server" Text="Buscar documento"/>
                                    <div class="input-group shadow-sm">
                                        <asp:TextBox ID="TxtSearchFile" runat="server" CssClass="form-control" placeholder="Nombre del archivo..."/>
                                        <asp:Button ID="BtnSearchFile" OnClick="BtnSearchFile_OnClick" runat="server" CssClass="btn btn-primary" Text="Buscar"/>
                                    </div>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <asp:GridView ID="GvDocuments" runat="server"
                                    CssClass="table table-hover align-middle" AutoGenerateColumns="false"
                                    GridLines="None"
                                              OnRowCommand="GvDocuments_OnRowCommand"
                                              >
                                    <HeaderStyle CssClass="table-light text-muted small text-uppercase" />
                                    
                                    <Columns>
                                        <asp:BoundField DataField="DocumentName" HeaderText="Nombre del Archivo" />
                                        <asp:BoundField DataField="FileExtension" HeaderText="Tipo" />
                                        
                                        <asp:TemplateField HeaderText="Tamaño">
                                            <ItemTemplate>
                                                <%# FormatSize(Eval("FileSize")) %>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="UploadDate" HeaderText="Fecha de Subida" DataFormatString="{0:dd/MM/yyyy}" />
                                        <asp:BoundField DataField="VersionNumber" HeaderText="Versión" />
                                        
                                        <asp:TemplateField HeaderText="Acciones">
                                            <ItemTemplate>
                                                <div class="d-flex gap-2">
                                                    <asp:LinkButton ID="BtnEdit" runat="server" CssClass="btn btn-sm btn-outline-primary"
                                                                    CommandName="NewVersion" CommandArgument='<%# Eval("DocumentId") %>'>
                                                        Nueva versión
                                                    </asp:LinkButton>

                                                    <asp:LinkButton ID="BtnDelete" runat="server" CssClass="btn btn-sm btn-outline-danger"
                                                                    CommandName="DeleteFile" CommandArgument='<%# Eval("DocumentId") %>'
                                                                    OnClientClick="return confirm('¿Estás seguro de que deseas eliminar este documento y todas sus versiones?');">
                                                        Eliminar
                                                    </asp:LinkButton>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

        </div>
    </div>

    <%-- region: Modal para subir el archivo --%>
    <div class="modal fade" id="modalUploadFile" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
      
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="tituloModal">Subir nuevo archivo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
      
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label text-muted" for="FupFile">Selecciona el archivo:</label>
                        <asp:FileUpload ID="FupFile" runat="server" CssClass="form-control" />
                    </div>
        
                    <asp:Label ID="LblFileData" runat="server" CssClass="d-block mt-2"></asp:Label>
                </div>
      
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancelar</button>
        
                    <asp:Button ID="BtnUploadFile" runat="server" Text="Subir archivo" 
                                CssClass="btn btn-primary shadow-sm rounded-pill fw-bold" OnClick="BtnUploadFile_Click" />
                </div>

            </div>
        </div>
    </div>
    <%-- endregion --%>
    
    <%-- region: Modal para nueva versión de archivo existente --%>
    <div class="modal fade" id="modalNewVersion" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold">Subir Nueva Versión</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted small">Selecciona el archivo actualizado. El sistema incrementará automáticamente el número de versión.</p>
                    <div class="mb-3">
                        <asp:FileUpload ID="FupNewVersion" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="BtnSubmitVersion" runat="server" Text="Actualizar Versión" 
                                CssClass="btn btn-primary rounded-pill fw-bold" OnClick="BtnSubmitVersion_Click" />
                </div>
            </div>
        </div>
    </div>
    <%-- endregion --%>

</asp:Content>
