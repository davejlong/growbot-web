expect = require('chai').expect
HeatMap = require '../../lib/growbot/web/views/coffee/heat_map'

describe 'HeatMap', ->
  heatMap = null
  beforeEach ->
    heatMap = new HeatMap()

  it 'has sane defaults', ->
    expect(heatMap._w).to.equal 940
    expect(heatMap._h).to.equal 430
    expect(heatMap._m).to.deep.equal { top: 50, right: 0, bottom: 100, left: 30 }

  describe '#width', ->
    describe 'as a setter', ->
      it 'returns itself', ->
        expect(heatMap.width(5)).to.equal heatMap
      it 'sets an instance variable', ->
        heatMap.width(5)
        expect(heatMap._w).to.equal 5
    describe 'as a getter', ->
      it 'returns the width', ->
        heatMap.width(6)
        expect(heatMap.width()).to.equal 6

  describe '#height', ->
    describe 'as a setter', ->
      it 'returns itself', ->
        expect(heatMap.height(5)).to.equal heatMap
      it 'sets an instance variable', ->
        heatMap.height(5)
        expect(heatMap._h).to.equal 5
    describe 'as a getter', ->
      it 'returns the height', ->
        heatMap.height(6)
        expect(heatMap.height()).to.equal 6

  # describe '#margin', ->
  #   describe 'as a setter', ->
  #     it 'sets specific margin', ->
  #       heatMap.margins('top', 6)
  #       expect(heatMap._m.top).to.equal 6
  #     it 'sets all margines to a single value', ->
  #       heatMap.margins(6)
  #       expect(heatMap._m).to.deep.equal { top: 6, right: 6, bottom: 6, left: 6 }
  #     it 'sets all margins with an object', ->
  #       heatMap.margins({top: 6, right: 7, bottom: 8, left: 9 })
  #       expect(heatMap._m).to.deep.equal { top: 6, right: 7, bottom: 8, left: 9 }
  #   describe 'as a getter', ->
  #     it 'gets a specific side', ->
  #       heatMap.margins('top', 6)
  #       expect(heatMap.margins('top')).to.equal 6
  #     it 'gets all margins', ->
  #       heatMap.margins({top: 6, right: 7, bottom: 8, left: 9 })
  #       expect(heatMap.margins()).to.deep.equal {top: 6, right: 7, bottom: 8, left: 9 }

