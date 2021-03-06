<%
	Option Explicit
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1

  If (CLng(Session("uid")) = 0) Then
		Response.Redirect Application("exit_page")
	End If
		
	Dim gnRuleGroupId, gnRuleDefId
	Dim gsCboCurrencies, gsCboSectors, gsCboOperators
	Dim gnStdAccountTypeId, gsRuleGroupName, gsGroupEntityId, gsCboTargetSectors
		
	Call Main()

	Sub Main()
		Dim oRule, oRuleDef, oRecordset, nSubsidiaryLedgerId, nSubsidiaryAccountId
		Dim nGLAccountId, nSectorId
		'*******************************************************************		
		gnRuleDefId   = CLng(Request.QueryString("ruleDefId"))
		gnRuleGroupId = CLng(Request.QueryString("Id"))
		If CLng(gnRuleGroupId) > 0 Then			
			gnRuleGroupId = gnRuleGroupId
			gsGroupEntityId = 16
		Else
			gnRuleGroupId = Abs(gnRuleGroupId)
			gsGroupEntityId = 9
		End If
		Set oRule     = Server.CreateObject("EFARulesMgrBS.CRule")
		'If gnRuleGroupId <> 0 Then
		'	Set oRecordset  = oRule.RuleRS(Session("sAppServer"), CLng(gnRuleGroupId))
	'		gsRuleGroupName = oRecordset("nombre_grupo_cuenta")
	'		gsGroupEntityId = oRecordset("id_entidad_agrupador")
	'	End If
		gsCboCurrencies = oRule.CboCurrencies(Session("sAppServer"))
		gsCboSectors		= oRule.CboSectors(Session("sAppServer"))
		gsCboTargetSectors = oRule.CboTargetSectors(Session("sAppServer"))
		gsCboOperators	= oRule.CboOperators(Session("sAppServer"))
		'Set oRecordset = Nothing		
		Set oRule  = Nothing
		
		Set oRuleDef = Server.CreateObject("EFARulesMgrBS.CRuleDefinition")
		gnStdAccountTypeId  = oRuleDef.RuleDefStdAccountTypeId(Session("sAppServer"), CLng(gnRuleDefId))
		Set oRuleDef = Nothing
	End Sub	
%>
<HTML>
<HEAD>
<TITLE>Rango de cuentas</TITLE>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<script language="JavaScript" src="/empiria/bin/ms_scripts/rs.htm"></script>
<link REL="stylesheet" TYPE="text/css" HREF="/empiria/resources/applications.css">
<script ID="clientEventHandlersJS" LANGUAGE="javascript">
<!--

function setAccountNumber(oControl) {
	var obj;	
	if (oControl.value != '') {
		obj = RSExecute("../financial_accounting_scripts.asp", "FormatStdAccountNumber", <%=gnStdAccountTypeId%> , oControl.value);
		if (obj.return_value != '') {
			oControl.value = obj.return_value;
		} else {
			alert("No entiendo el formato de la cuenta proporcionada.");
		}
	}
	return true;
}

function txtFromAccount_onblur() {
	setAccountNumber(document.all.txtFromAccount);
}

function txtToAccount_onblur() {
	setAccountNumber(document.all.txtToAccount);
}

function txtTargetAccount_onblur() {
	setAccountNumber(document.all.txtTargetAccount);
}

function txtTargetOBAccount_onblur() {
	setAccountNumber(document.all.txtTargetOBAccount);
}

function validate() {
	if (document.all.txtFromAccount.value == '') {
		alert("Requiero al menos el n?mero de cuenta inicial del rango.");
		document.all.txtFromAccount.focus;
		return false;
	}
	if (document.all.txtFactor.value == '') {
		alert("Requiero el factor que se le aplicar? al rango");
		document.all.txtFactor.focus;
		return false;
	}
	return true;
}

function sendInfo() {
	if (validate()) {
		document.frmEditor.submit();
	}
}

//-->
</SCRIPT>
</HEAD>
<BODY scroll=no>
<TABLE border=0 cellPadding=3 cellSpacing=1 width="100%">
<TR bgcolor=khaki height=25>
  <TD>
		<FONT face=Arial color=maroon><STRONG>Insertar rango de cuentas en <%=gsRuleGroupName%></STRONG></FONT>		
  </TD>
  <TD nowrap align=right>
		<A href='' onclick='sendInfo();return false;'>Aceptar</A>&nbsp;&nbsp;
 		<A href='' onclick='window.close();return false;'>Cancelar</A>
  </TD>
</TR>
</TABLE>
<FORM name=frmEditor action="./exec/save_voucher_rule.asp" method="post">
<TABLE border=0 cellPadding=2 cellSpacing=1 width="100%">
<TR>
  <TD>Desde la cuenta (origen):</TD>
  <TD><INPUT name=txtFromAccount maxlength=255 style="width:100%" LANGUAGE=javascript onblur="return txtFromAccount_onblur()"></TD>
</TR>
<TR>
  <TD>Hasta la cuenta (origen):</TD>
  <TD><INPUT name=txtToAccount maxlength=255 style="width:100%" LANGUAGE=javascript onblur="return txtToAccount_onblur()"></TD>
</TR>
<TR>
  <TD>Auxiliar (origen):</TD>
  <TD><INPUT name=txtSubsidiaryAccount maxlength=255 style="width:100%"></TD>
</TR>
<TR>
  <TD valign=top>Moneda (origen):</TD>
	<TD>
		<SELECT name=cboCurrencies style="WIDTH: 100%">
			<%=gsCboCurrencies%>
		</SELECT>
		<INPUT type="checkbox" name=chkCurrencies value="true">Saldos de todas las monedas excepto la seleccionada
	</TD>
</TR>
<TR>
  <TD valign=top>Sector (origen):</TD>
	<TD>
		<SELECT name=cboSectors style="WIDTH: 100%"> 
			<%=gsCboSectors%>
		</SELECT>		
		<INPUT type="checkbox" name=chkSectors value="true">Saldos de todos los sectores excepto el seleccionado
	</TD>
</TR>
<TR>
  <TD valign=top>Restricci?n:</TD>
  <TD>
		<TEXTAREA name=txtRestriction ROWS=2 style="width:100%"></TEXTAREA>
	</TD>  
</TR>
<TR>
  <TD>Cuenta destino:</TD>
  <TD><INPUT name=txtTargetAccount maxlength=255 style="width:100%" LANGUAGE=javascript onblur="return txtTargetAccount_onblur()"></TD>
</TR>
<TR>
  <TD>Auxiliar destino:</TD>
  <TD><INPUT name=txtTargetSubsidiaryAccount maxlength=255 style="width:100%" LANGUAGE=javascript onblur="return txtToAccount_onblur()"></TD>
</TR>
<TR>
  <TD>Sector destino:</TD>
  <TD>
		<SELECT name=cboTargetSectors style="WIDTH: 100%"> 
			<%=gsCboTargetSectors%>
		</SELECT>
	</TD>  
</TR>
<TR>
  <TD>Cuenta destino sobregiro:</TD>
  <TD><INPUT name=txtTargetOBAccount maxlength=255 style="width:100%" LANGUAGE=javascript onblur="return txtTargetOBAccount_onblur()"></TD>
</TR>
<TR>
  <TD>Auxiliar destino sobregiro:</TD>
  <TD><INPUT name=txtTargetOBSubsidiaryAccount maxlength=255 style="width:100%" LANGUAGE=javascript onblur="return txtToAccount_onblur()"></TD>
</TR>
<INPUT name=txtFactor type=hidden value=1>
<INPUT name=txtRuleId type=hidden value=0>
<INPUT name=txtRuleGroupId type=hidden value=<%=gnRuleGroupId%>>
<INPUT name=txtRuleDefId type=hidden value=<%=gnRuleDefId%>>
<INPUT name=txtRuleTypeId type=hidden value=4>
<INPUT name=txtGroupEntityId type=hidden value=<%=gsGroupEntityId%>>
</TABLE>
</FORM>
</BODY>
<script language="JavaScript">RSEnableRemoteScripting("/empiria/bin/ms_scripts/")</script>
</HTML>