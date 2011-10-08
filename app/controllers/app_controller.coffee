class Fraktioncalculator.AppController extends Batman.Controller
  calc: null
  index: ->
    $('#container').fadeIn(1000)
    $('#operators').selectable()
    $('#calculations').sortable()
    @set 'calc', new Calculation
    @render no

  setOperator: (e, ui) ->
    @set 'calc.operator', $(ui.selected).text()
    console.log @get 'calc.operator'

  reset: =>
    @set 'calc', new Calculation
      operator: @get 'calc.operator'
      shortening: @get 'calc.shortening'

  create: =>
    @calc.save (error, record) =>
      throw error if error
      x = Calculation.all.toArray()
      x = x[x.length - 1]
      @set 'calc', new Calculation
        operator: @get 'calc.operator'
        shortening: @get 'calc.shortening'
        denominator1: x.get 'denominatorResult'
        numerator1: x.get 'numeratorResult'
      $('#calculations').scrollTop(9999)


  edit: =>
    @set 'calc', new Calculation

  clear: =>
    for i in Calculation.all.toArray()
      i.destroy()

  shortening: =>
    @set 'calc.shortening', not @get('calc.shortening')

  reedit: (el, evt)=>
    $elems = $('.calc')
    for i in  [0...$elems.length]
      if el is $elems[i]
        x = i
        break
    m = Calculation.all.toArray()[x]
    if m
      op = m.get 'operator'
      $ops = $('#operators')
      @set 'calc', new Calculation 
        denominator1: m.get 'denominator1'
        denominator2: m.get 'denominator2'
        numerator1: m.get 'numerator1'
        numerator2: m.get 'numerator2'
        operator: op
        shortening: @get 'calc.shortening'
      $ops.find('.ui-selected').removeClass('ui-selected')
      for o in $ops.children()
        if $(o).html() is op
          console.log op
          $(o).addClass('ui-selected')
      m.destroy()


