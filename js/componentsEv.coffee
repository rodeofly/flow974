actionSocket = new (D3NE.Socket)('act', 'Action', 'hint')
dataSocket = new (D3NE.Socket)('data', 'Data', 'hint')


eventHandlers = 
  list: []
  remove: ->
    @list.forEach (h) =>
      document.removeEventListener 'keydown', h
      return
    @list = []
    return
  add: (name, h) ->
    document.addEventListener name, h, false
    @list.push h
    return

keydownComp = new (D3NE.Component)('Touche enfoncée',
  builder: (node) ->
    node.addOutput(new (D3NE.Output)('', actionSocket)).addOutput new (D3NE.Output)('Code touche', dataSocket)
  worker: (node, inputs, outputs) ->
    task = new (D3NE.Task)(inputs, (inps, data) ->
      console.log 'Keydown event', node.id, data
      [ data ]
)
    eventHandlers.remove()
    eventHandlers.add 'keydown', (e) ->
      task.run e.keyCode
      task.reset()
      return
    outputs[0] = task.option(0)
    outputs[1] = task.output(0)
    return
)


enterpressComp = new (D3NE.Component)('Entrée pressée',
  builder: (node) ->
    node.addInput(new (D3NE.Input)('', actionSocket)).addInput(new (D3NE.Input)('Code touche', dataSocket)).addOutput(new (D3NE.Output)('A1ors', actionSocket)).addOutput new (D3NE.Output)('Sinon', actionSocket)
  worker: (node, inputs, outputs) ->
    task = new (D3NE.Task)(inputs, (inps) ->
      if inps[0][0] == 13
        @closed = [ 1 ]
      else
        @closed = [ 0 ]
      console.log 'Print', node.id, inps
      return
)
    outputs[0] = task.option(0)
    outputs[1] = task.option(1)
    return
)


alertComp = new (D3NE.Component)('Alerte',
  builder: (node) ->
    ctrl = new (D3NE.Control)('<input type="text" value="Message...">', (el, c) =>

      upd = ->
        c.putData 'msg', el.value
        return

      el.addEventListener 'mousedown', (e) ->
        e.stopPropagation()
        return
      el.addEventListener 'keydown', (e) ->
        e.stopPropagation()
        return
      el.value = c.getData('msg')
      el.addEventListener 'change', upd
      upd()
      return
)
    node.addControl(ctrl).addInput new (D3NE.Input)('', actionSocket)
  worker: (node, inputs, outputs) ->
    task = new (D3NE.Task)(inputs, ->
      console.log 'Alert', node.id, node.data
      alert node.data.msg
      return
)
    return
)

