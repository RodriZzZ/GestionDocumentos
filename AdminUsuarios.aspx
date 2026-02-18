<%@ Page Title="" Language="C#" MasterPageFile="~/MenuPrincipal.master" AutoEventWireup="true" CodeBehind="AdminUsuarios.aspx.cs" Inherits="GestionDocumentos.AdminUsuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <h1 class="text-center">ADMINISTRADOR DE USUARIO</h1>
        <div class="row">
            <div class="w-100 d-flex justify-content-start">
                <a class="btn btn-primary mb-3" href="AdminUsuarioForm.aspx">Crear usuario</a>
            </div>
            <div class="col-12">
                <table class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>NOMBRE</th>
                            <th>USUARIO</th>
                            <th>ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < 10; i++)
                            { %>
                        <tr id="<%: i+1 %>">
                            <td><%: i+1 %></td>
                            <td>NOMBRE APELLIDO <%: i+1 %></td>
                            <td>USUARIO  <%: i+1 %></td>
                            <td>
                                <a class="btn btn-sm btn-light" data-bs-toggle="tooltip" data-bs-placemente="top" data-bs-title="editar" title="editar" href="AdminUsuarioForm.aspx?id=<%: i+1 %>">✏️</a>
                                <a class="btn btn-sm btn-light" data-bs-toggle="tooltip" data-bs-placemente="top" data-bs-title="eliminar" title="eliminar" href="javascript:void(0)">🗑️</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td class="text-right" colspan="4">
                                <nav aria-label="Page navigation example">
                                  <ul class="pagination justify-content-center">
                                    <li class="page-item"><a class="page-link" href="#">Previous</a></li>
                                    <li class="page-item"><a class="page-link" href="#">1</a></li>
                                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                                    <li class="page-item"><a class="page-link" href="#">Next</a></li>
                                  </ul>
                                </nav>
                            </td>
                        </tr>
                    </tfoot>
                </table>

            </div>
        </div>
    </div>
</asp:Content>
