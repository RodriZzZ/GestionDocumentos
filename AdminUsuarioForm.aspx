<%@ Page Title="" Language="C#" MasterPageFile="~/MenuPrincipal.master" AutoEventWireup="true" CodeBehind="AdminUsuarioForm.aspx.cs" Inherits="GestionDocumentos.AdminUsuarioEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">


                <h2 id="tituloForm" class="text-center mb-3">Formulario de Usuario</h2>


                <div id="alertaEdicion" class="alert alert-info d-none">
                    Editando usuario con ID: <strong id="textoId"></strong>
                </div>


                <div class="mb-3">
                    <label class="form-label">NOMBRES</label>
                    <input id="txtNombres" type="text" class="form-control" placeholder="Ingrese nombres" />
                </div>

                <div class="mb-3">
                    <label class="form-label">APELLIDOS</label>
                    <input id="txtApellidos" type="text" class="form-control" placeholder="Ingrese apellidos" />
                </div>

                <div class="mb-3">
                    <label class="form-label">NOMBRE DE USUARIO</label>
                    <input id="txtUsuario" type="text" class="form-control" placeholder="Ingrese usuario" />
                </div>

                <div class="d-flex gap-2">
                    <a href="AdminUsuarios.aspx" class="btn btn-secondary">Cancelar</a>
                    <button type="button" id="btnGuardar" class="btn btn-primary">Guardar</button>
                </div>


                <!-- Mensaje "simulado" (solo frontend) -->
                <div id="msg" class="alert alert-success mt-3 d-none"></div>

            </div>
        </div>
    </div>

    <script>
        (function () {
            // 1) Detectar si hay ?id= en la URL
            const params = new URLSearchParams(window.location.search);
            const id = params.get('id');

            const titulo = document.getElementById('tituloForm');
            const alerta = document.getElementById('alertaEdicion');
            const textoId = document.getElementById('textoId');

            const txtNombres = document.getElementById('txtNombres');
            const txtApellidos = document.getElementById('txtApellidos');
            const txtUsuario = document.getElementById('txtUsuario');

            const btnGuardar = document.getElementById('btnGuardar');
            const msg = document.getElementById('msg');

            // 2) Modo Crear vs Editar (solo visual)
            if (id) {
                // Modo EDITAR
                titulo.textContent = 'Editar Usuario';
                alerta.classList.remove('d-none');
                textoId.textContent = id;

                // (Opcional) Relleno simulado para "editar"
                txtNombres.value = 'Nombre ' + id;
                txtApellidos.value = 'Apellido ' + id;
                txtUsuario.value = 'usuario' + id;
            } else {
                // Modo CREAR
                titulo.textContent = 'Crear Usuario';
                alerta.classList.add('d-none');
            }

            // 3) Guardar (simulado; no hay backend)
            btnGuardar.addEventListener('click', function () {
                // Sólo mostramos un mensajito para demostrar la interacción
                msg.textContent = id
                    ? 'Cambios (simulados) guardados para el ID ' + id + '.'
                    : 'Usuario (simulado) creado.';
                msg.classList.remove('d-none');

                // (Opcional) Limpiar campos si es "crear"
                if (!id) {
                    txtNombres.value = '';
                    txtApellidos.value = '';
                    txtUsuario.value = '';
                }
            });
        })();
    </script>

</asp:Content>
