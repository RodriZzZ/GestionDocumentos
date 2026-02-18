<%@ Page Title="Title" Language="C#" MasterPageFile="~/Site.Master" CodeBehind="FileDashboard.aspx.cs" Inherits="GestionDocumentos.FileDashboard" %>

<asp:Content ID="FileDashboardContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .flex {
            display: flex;
        }

        .flex-col {
            flex-direction: column;
        }

        .flex-row {
            flex-direction: row;
        }

        #root {
            display: grid;
            grid-te
        }

        .mr-8 {
            margin-inline-end: 2rem;
        }
        
       
        .gap-4 {
            gap: 1rem;    
        }
    </style>

    <asp:LoginName ID="LblLoggedUserWelcome" runat="server" Text="Bienvenid@ usuario"></asp:LoginName>
    <main class="flex flex-row">
        <aside class="mr-8">
            <asp:Button ID="BtnUpdateFile" Text="Subir archivo" runat="server"></asp:Button>
            
            <nav>
                <ul>
                    <li>
                        Mis archivos
                    </li>
                    
                    <li>
                        Archivos compartidos
                    </li>
                </ul>
            </nav>
            
        </aside>

        <section class="flex flex-col">
            <h1> Mis archivos </h1>

            <div class="flex flex-col gap-4">
                <asp:DropDownList ID="FilterOptions" runat="server">
                    <asp:ListItem Value="0">Por fecha ascendente</asp:ListItem>
                    <asp:ListItem Value="1">Por fecha descendente</asp:ListItem>
                    <asp:ListItem Value="2">Por nombre ascendente</asp:ListItem>
                    <asp:ListItem Value="3">Por nombre descendente</asp:ListItem>
                </asp:DropDownList>
                
                <div>
                    <label for="SearchFile">Buscar archivo:</label>
                    <input id="SearchFile" type="text" />
                </div>
            </div>
            
            <asp:GridView ID="GridView1" runat="server">
            </asp:GridView>
        </section>
    </main>
</asp:Content>    
