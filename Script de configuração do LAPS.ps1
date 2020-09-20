# Script de configuração do LAPS - Créditos Gabriel Luiz - www.gabrielluiz.com ##

<#

Após instalar o LAPS em seu servidor ADDS, execute os comandoa baixo, seguindo o artigo: http://gabrielluiz.com/2020/09/laps 

<#


Modificando o Active Directory Schema.

Dois atributos devem ser adicionados aos objetos do computador:

msMcsAdmPwd
msMcsAdmPwdExpirationTime

#>

Import-Module AdmPwd.PS

Update-AdmPwdADSchema


<#
Configurando permissões.

Os computadores de domínio devem ter permissões de gravação para renovar a senha do administrador local. No meu caso, concedo acesso a todos os computadores da Unidade Organizacional " ".

#>

Set-AdmPwdComputerSelfPermission -Identity Desktops



<#

Agora temos que configurar permissões de grupo. Todos os membros do grupo deste grupo poderão ler a senha local de cada computador de formar centralizada. Concedendo "ler permissão de senha" para o grupo de Administradores do Domínio.

#>

Set-AdmPwdReadPasswordPermission -OrgUnit Desktops -AllowedPrincipals "Administradores do Domínio" # Português

Set-AdmPwdReadPasswordPermission -OrgUnit Desktops -AllowedPrincipals "Domain-Admins" # Inglês

<#

Em seguida, configuramos o direito de redefinir a senha da conta do administrador local. Como antes, eu permito isso para todos os Administradores do Domínio.

#>

Set-AdmPwdResetPasswordPermission -OrgUnit Desktops -AllowedPrincipals "Administradores do Domínio" # Português

Set-AdmPwdResetPasswordPermission -OrgUnit Desktops -AllowedPrincipals "Domain-Admins" # Inglês


<#

Crie uma pasta e um compartilhamento de pasta.

Primeiro, temos que criar uma pasta e colocar os arquivos de instalação nela. Tudo o que precisamos é Powershell e o pacote de instalação .msi. Crie a pasta.

Para criar uma pasta no servidor e abra o PowerShell como Administrador e execute o seguinte comando:

#>

New-Item -Itemtype Directory -Name LAPS -Path C:\

<#

Uma vez criada a pasta, ative o compartilhamento.

Para ativar o compartilhamento de pasta no servidor e abra o PowerShell como Administrador e execute o seguinte comando:

#>

New-SmbShare -Name LAPS -Path C:\LAPS\

<#

Verificar a senha do usuário administrador local do computador.

Também podemos utilizar o Powershell como alternativa para verificar a senha do usuário administrador local do computador. Para isso execute o Powershell como administrador e execute o seguinte comando:


Import-Module AdmPwd.PS

Get-AdmPwdPassword -ComputerName W10-1 | Format-List

#>


<#

Referência

https://docs.microsoft.com/en-us/previous-versions/mt227395(v=msdn.10)?redirectedfrom=MSDN/?WT.mc_id=WDIT-MVP-5003815

#>