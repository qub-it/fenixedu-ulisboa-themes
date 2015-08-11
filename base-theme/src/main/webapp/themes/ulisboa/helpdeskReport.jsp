
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="org.fenixedu.commons.i18n.I18N" %>

<fmt:setLocale value='<%= I18N.getLocale().getLanguage() %>'/>
<fmt:setBundle basename="resources.ULisboaThemeResources" var="lang"/>

<div class="modal-dialog modal-lg">
    <div class="modal-content">
        <form id="supportForm" class="form-horizontal">
        <input type="hidden" name="userAgent" value="${pageContext.request.getHeader('User-Agent')}" />
        <input type="hidden" name="referer" value="${pageContext.request.getHeader('Referer')}" />
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
            <h4 class="modal-title" id="myModalLabel"><fmt:message key="label.helpdesk.form" bundle="${lang}"/></h4>
        </div>
        <div class="modal-body form-body">
            <fmt:message key="label.helpdesk.form.welcome" bundle="${lang}"/>
            <hr />
                <div class="form-group">
                    <label for="subject" class="col-sm-2 control-label"><fmt:message key="label.helpdesk.report.subject" bundle="${lang}"/>:</label>
                    <div class="col-sm-10">
                        <input type="text" name="subject" id="subject" class="form-control" required />
                    </div>
                </div>
                <div class="form-group">
                    <label for="description" class="col-sm-2 control-label"><fmt:message key="label.helpdesk.report.description" bundle="${lang}"/>:</label>
                    <div class="col-sm-10">
                        <textarea id="description" name="description" rows="5" style="width: 100%" required></textarea>
                        <small><fmt:message key="label.helpdesk.report.description.tooltip" bundle="${lang}"/></small>
                    </div>
                </div>
                <div class="form-group">
                    <label for="type" class="col-sm-2 control-label"><fmt:message key="label.helpdesk.report.type" bundle="${lang}"/>:</label>
                    <div class="col-sm-10">
                        <label class="radio-inline" style="padding-left: 0;">
                            <input type="radio" name="type" style="margin: 2px 0 0 0; margin-right: 5px;" id="type-error" value="error" checked required >
                            <fmt:message key="label.helpdesk.report.type.error" bundle="${lang}"/>
                        </label>
                        <label class="radio-inline" style="padding-left: 0;">
                            <input type="radio" name="type" style="margin: 2px 0 0 0; margin-right: 5px;" id="type-request" value="request" >
                            <fmt:message key="label.helpdesk.report.type.request" bundle="${lang}"/>
                        </label>
                        <label class="radio-inline" style="padding-left: 0;">
                            <input type="radio" name="type" style="margin: 2px 0 0 0; margin-right: 5px;" id="type-question" value="question">
                            <fmt:message key="label.helpdesk.report.type.question" bundle="${lang}"/>
                        </label>
                    </div>
                </div>
                <div class="form-group">
                    <label for="attachment" class="col-sm-2 control-label"><fmt:message key="label.helpdesk.report.attachment" bundle="${lang}"/>:</label>
                    <div class="col-sm-10">
                        <div class="alert alert-danger" id="largeFile" style="display: none">
                            <fmt:message key="label.helpdesk.report.attachment.file.too.large" bundle="${lang}"/>
                        </div>
                        <input type="file" name="attachment" id="attachment" />
                        <small><fmt:message key="label.helpdesk.report.attachment.tooltip" bundle="${lang}"/></small>
                    </div>
                </div>
        </div>
        <div class="modal-body success text-center hide">
            <h3><fmt:message key="label.helpdesk.report.submitted" bundle="${lang}"/></h3>
            <fmt:message key="label.helpdesk.report.submitted.body" bundle="${lang}"/> <a href="mailto:changeme@to.do">changeme@to.do</a>.
        </div>
        <div class="modal-footer">
            <button type="submit" class="btn btn-primary"><fmt:message key="label.helpdesk.report.submit" bundle="${lang}"/></button>
        </div>
        </form>
    </div>
</div>

<script>
var data = { 'functionality': window.current$functionality };
$.ajaxSetup({ headers: {'Content-Type':'application/json; charset=UTF-8'} });
$('#supportForm input[type=file]').on('change', function (event) {
    var file = event.target.files[0];
    $('#largeFile').hide();
    if(file.size > 5 * 1024 * 1024) {
        $('#largeFile').show();
        return;
    }
    var reader = new FileReader();
    data['fileName'] = file.name;
    data['mimeType'] = file.type;
    reader.onload = function (e) {
        var content = e.target.result;
        data['attachment'] = content.substr(content.indexOf(",") + 1, content.length);
    };
    reader.readAsDataURL(file);
});
$('#supportForm').on('submit', function(event) {
    event.preventDefault();
    var target = $(event.target);
    $.map(target.serializeArray(), function(n, i){
        data[n['name']] = n['value'];
    });
    target.find('button[type=submit]').html("<fmt:message key='label.helpdesk.report.error.submitting' bundle='${lang}'/>...");
    target.find('button[type=submit]').attr('disabled', true);
    $.post('${pageContext.request.contextPath}/fenixedu-ulisboa-specifications/helpdeskreport/submitReport', JSON.stringify(data), function () {
        target.find('.success').removeClass('hide');
        target.find('.modal-footer').hide();
        target.find('.form-body').hide();
    });
});
</script>
