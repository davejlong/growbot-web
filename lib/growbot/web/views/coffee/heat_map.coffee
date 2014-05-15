(() ->
  class HeatMap
    _w: 940
    _h: 430
    _m: { top: 50, right: 0, bottom: 100, left: 30 }

    constructor: ->

    # Setter/Getter for width
    # @param w [Number] Width to set
    # @returns [Object] This instance of the HeatMap if setter
    # @returns [Object] Width if getter
    width: (w) ->
      if w then @_w = w; return this
      else return @_w

    # Setter/Getter for width
    # @param h [Number] Height to set
    # @returns [Object] This instance of the HeatMap if setter
    # @returns [Number] Height if getter
    height: (h) ->
      if h then @_h = h; return this
      else return @_h

    # Setter/Getter for margine
    # @param margins [Object] Object containing 4 margins to set
    # @param side [String] Side to set margin for (top, right, bottom, left)
    # @param size [Number] Size of margin
    # @returns [Object] Margins if getter without side arguments
    # @returns [Number] Specific margin if getter with side argument
    # @returns [Object] This instance of the HeatMap if setter
    margins: () ->
      return @_m unless arguments.length
      if typeof arguments[0] is 'object'
        @_set_margin_from_object arguments[0]

    # Private methods
    _set_margin_from_object: (margins) ->
      @_m[side] = size for side, size of margins

  module.exports = HeatMap
)(module)
