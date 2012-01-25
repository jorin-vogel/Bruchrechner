class Fractioncalculator.AppController extends Batman.Controller
  
  calc: null
  
  index: ->
    #smooth loading
    $('#container').fadeIn(1000)
    
    #activating jQueryUI stuff
    $('#operators').selectable()
    $('#calculations').sortable()

    #set the calculation in this opject to 
    #a new instance of the Calculation Model 
    @set 'calc', new Calculation

    #prevent the default action which would 
    #search by configuration for a file index.html
    #and render it
    @render no


  #called when the user changes the operator by clicking
  setOperator: (e, ui) ->
    @set 'calc.operator', $(ui.selected).text()
    console.log @get 'calc.operator'

  #handler for the reset-button
  reset: =>
    #resets the current calculation
    @set 'calc', new Calculation
      operator: @get 'calc.operator'
      shortening: @get 'calc.shortening'


  create: =>
    #saves the current calcualtion into localstorage
    #and adds it to the calculation collection
    @calc.save (error, record) =>
      throw error if error
      x = Calculation.all.toArray()
      x = x[x.length - 1]
      #after saving we have to reset the calculation
      #so we fetch the necessary data from the last calculation
      @set 'calc', new Calculation
        operator: @get 'calc.operator'
        shortening: @get 'calc.shortening'
        denominator1: x.get 'denominatorResult'
        numerator1: x.get 'numeratorResult'
      #because the collection of old calculations
      #got bigger, we have to scroll it a bit
      $('#calculations').scrollTop(9999)


  clear: =>
    #destroy all calculations
    for i in Calculation.all.toArray()
      i.destroy()


  shortening: =>
    #toggle the shortening-flag
    #it's a boolean
    @set 'calc.shortening', not @get('calc.shortening')


  reedit: (el, evt)=>
    #get the position of the clicked element inside
    #the dom-element
    $elems = $('.calc')
    for i in  [0...$elems.length]
      if el is $elems[i]
        x = i
        break
    #use the position to get the appropriate model
    #and set its data to the main calculation
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
      #at this point we need to set the activated operators
      #view-state manually
      $ops.find('.ui-selected').removeClass('ui-selected')
      for o in $ops.children()
        if $(o).html() is op
          console.log op
          $(o).addClass('ui-selected')
      #and finally we can remove the selected model 
      #out of the calculation collection
      m.destroy()


