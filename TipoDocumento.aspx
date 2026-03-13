<%@ Page Title="" Language="C#" MasterPageFile="~/MenuPrincipal.master" AutoEventWireup="true" CodeBehind="TipoDocumento.aspx.cs" Inherits="GestionDocumentos.TipoDocumento" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body p-4">
                        <h4 class="fw-bold mb-3 text-primary">Clasificación de Documento</h4>

                        <label class="form-label small fw-bold">Nombre de la Categoría</label>
                        <asp:TextBox ID="txtNombreTipo" runat="server" CssClass="form-control rounded-pill"
                            placeholder="Ej: Legal, Tesis, Fiscal..."></asp:TextBox>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Descripción</label>
                            <asp:TextBox ID="txtDescripcionTipo" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control rounded-3" placeholder="Breve descripción..."></asp:TextBox>
                        </div>
                        <div class="d-grid gap-2">
                            <asp:Button ID="btnGuardarTipo" runat="server" Text="Guardar Tipo" CssClass="btn btn-primary rounded-pill fw-bold" />
                            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-outline-secondary btn-sm rounded-pill" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body p-4">
                        <h4 class="fw-bold mb-4">Tipos Registrados</h4>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-dark small text-uppercase">
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre</th>
                                        <th>Descripción</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>1</td>
                                        <td><span class="badge bg-info text-dark">Tesis</span></td>
                                        <td class="small text-muted">Documentos de solo lectura</td>
                                        <td class="text-center">
                                            <button class="btn btn-sm btn-light border">✏️</button>
                                            <button class="btn btn-sm btn-light border">🗑️</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td><span class="badge bg-success">Documento legal</span></td>
                                        <td class="small text-muted">Hojas de cálculo e informes</td>
                                        <td class="text-center">
                                            <button class="btn btn-sm btn-light border">✏️</button>
                                            <button class="btn btn-sm btn-light border">🗑️</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
