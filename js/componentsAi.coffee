botAvatar = 'https://robohash.org/liberovelitdolores.bmp?size=50x50&set=set1'
userAvatar = 'http://icons.iconarchive.com/icons/visualpharm/must-have/256/User-icon.png'
telegram = new Vue
  el: '#telegram'
  data:
    botSleep: 1000
    textfield: ''
    users: [
      {
        avatar: botAvatar
        username: 'Halmstad'
      }
      {
        avatar: userAvatar
        username: 'Wako'
        owner: true
      }
    ]
    messages: [
      {
        user: 0
        text: 'Salut, je suis un bot dans un Messenger. Je peux être programmé sans taper de ligne de code. Il suffit d\'utiliser l\'éditeur à gauche. Pour l\instant je ne comprend que -hello-, tout le reste me fait sourire !'
      }
      {
        user: 0
        text: 'Alors parle moi, dis moi hello !'
      }
    ]
  methods:
    formatMsg: (msg) -> msg.replace /\[(.+?)\]\((.+?)\)/g, '<a target="_blank" href="$2">$1</a>'
    
    onMessage: ->
      ms = @$refs.messages
      delay 100, => ms.scrollTop = ms.scrollHeight

    sendOwner: (message) ->
      @messages.push
        user: 1
        text: message
      receiveBot message
      @onMessage()

    sendBot: (message) ->
      @messages.push
        user: 0
        text: message
      @onMessage()


onMessageTask = null

receiveBot  = (msg) -> delay telegram.botSleep, => await onMessageTask.run(msg)
receiveUser = (msg) -> telegram.sendBot msg
  
actSocket = new (D3NE.Socket)('action', 'Action', 'hint')
strSocket = new (D3NE.Socket)('string', 'String', 'hint')

componentMessageEvent = new (D3NE.Component)('Évènement Message',
  builder: (node) ->
    out1 = new (D3NE.Output)('Action', actSocket)
    out2 = new (D3NE.Output)('Text', strSocket)
    node.addOutput(out1).addOutput out2
    
  worker: (node, inputs, outputs) ->
    task = (onMessageTask = new (D3NE.Task)(inputs, (inps, msg) => return [ msg ]))
    outputs[0] = task.option(0)
    outputs[1] = task.output(0)
)

componentMessageSend = new (D3NE.Component)('Message envoyé',
  builder: (node) ->
    inp1 = new (D3NE.Input)('Action', actSocket)
    inp2 = new (D3NE.Input)('Text', strSocket)
    node.addInput(inp1).addInput inp2
    
  worker: (node, inputs, outputs) ->
    task = new (D3NE.Task)(inputs, (inps) =>
      console.log inps
      text = if inps[0] then inps[0][0] else '...'
      #default text
      console.log 'msg send'
      receiveUser text
    )
)

componentMessageMatch = new (D3NE.Component)('Message identique',
  builder: (node) ->
    inp1 = new (D3NE.Input)('Action', actSocket)
    inp2 = new (D3NE.Input)('Text', strSocket)
    out1 = new (D3NE.Output)('True', actSocket)
    out2 = new (D3NE.Output)('False', actSocket)
    ctrl = new (D3NE.Control)('<input>', (el, control) =>
      text = control.getData('regexp') or '.*'
      el.value = text
      control.putData 'regexp', text
      el.addEventListener 'change', () => control.putData 'regexp', el.value
    )
    node.addControl(ctrl).addInput(inp1).addInput(inp2).addOutput(out1).addOutput out2
  
  worker: (node, inputs, outputs) ->
    task = new (D3NE.Task)(inputs, (inps) =>
      text = if inps[0] then inps[0][0] else ''
      if !text.match(new RegExp(node.data.regexp, 'gi'))
        task.closed = [ 0 ]
      else
        task.closed = [ 1 ]
    )
    outputs[0] = task.option(0)
    outputs[1] = task.option(1)
)

componentMessage = new (D3NE.Component)('Message',
  builder: (node) ->
    out = new (D3NE.Output)('Text', strSocket)
    ctrl = new (D3NE.Control)('<input>', (el, control) =>
      text = control.getData('text') or 'Some message..'
      el.value = text
      control.putData 'text', text
      el.addEventListener 'change', () => control.putData 'text', el.value
    )
    node.addControl(ctrl).addOutput out
    
  worker: (node, inputs, outputs) ->
    task = new (D3NE.Task)(inputs, (inps) => return [ node.data.text ])
    outputs[0] = task.output(0)
)




