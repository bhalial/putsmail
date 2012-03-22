class Putsmail.Views.TestMailsIndex extends Backbone.View

  template: JST['test_mails/index']

  events:
    "submit #form_test_email": "sendTest"
    "focus .test_mail_cc input[name='test_mail_users_mail']": "makeVisible"
    "blur  .test_mail_cc input[name='test_mail_users_mail']": "checkFilled"
    

  render: ->
    $(@el).html(@template)
    this

  showCC: (event) ->
    event.preventDefault()
    $(".test_mail_cc").show 500, ->
      firstCc = $(".test_mail_cc input[name='test_mail_users_mail']").first()
      firstCc.focus()
      firstCc.css("opacity", 1)

  makeVisible: (event) ->
    obj = $(event.target)
    obj.parent().parent().css("opacity", 1)

  checkFilled: (event) ->
    obj = $(event.target)
    if not _.isEmpty obj.val()
      obj.parent().parent().css("opacity", 1)
    else
      obj.parent().parent().css("opacity", .5)

  sendTest: (event) ->
    @clearPreviousErrors()
    event.preventDefault()
    recipients = _.map $("input[name=test_mail_users_mail]"), 
       (recipient) -> $(recipient).val()
    testMail = new Putsmail.Models.TestMail
    testMail.save {test_mail: 
         body: $("#test_mail_body").val()
         subject: $("#test_mail_subject").val()
         recipients: recipients}
      wait: true
      success:(model, response) -> alert "saved"
      error: @handleError

  clearPreviousErrors: ->
    $("span.error_message").remove()
    $("div.error").removeClass("errorß")

  handleError: (model, response) ->
    if response.status == 422
      errors = $.parseJSON(response.responseText)
      for attribute, messages of errors
        for message in messages
          input = $("input[name=#{attribute}], textarea[name=#{attribute}], input[id=#{attribute}]")
          if input.length > 0
            input.parent().parent().addClass("error")
            input.after("<span class=\"help-inline error_message\">#{message}</span>")
