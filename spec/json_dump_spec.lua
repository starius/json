--luacheck: ignore describe it setup teardown
describe('json.dump()', function()
  local json = require('json')
  local function check(filename, ...)
    local e = json.load(filename)
    local df = 'dump.json'
    json.dump(e, df, ...)
    local a = json.load(df)
    --os.remove(df)
    return e, a
  end
  setup(function()
    os.remove('dump.json')
  end)
  teardown(function()
    os.remove('dump.json')
  end)
  it('when load valid json file', function()
    local e, a = check('rapidjson/bin/jsonchecker/pass1.json')
    assert.are.same(string.format("%.10g", e[9]['E']), string.format("%.10g", a[9]['E']))
    assert.are.same(string.format("%.10g", e[9]['']),string.format("%.10g", a[9]['']))
    a[9]['E'], a[9][''], e[9]['E'], e[9][''] = nil, nil, nil, nil
    assert.are.same(e, a)

    assert.are.same(check('rapidjson/bin/jsonchecker/pass2.json'))
    assert.are.same(check('rapidjson/bin/jsonchecker/pass3.json'))
  end)

  it('should dump with pretty option = true', function()
    local option = {pretty=true}
    local e, a = check('rapidjson/bin/jsonchecker/pass1.json', option)
    assert.are.same(string.format("%.10g", e[9]['E']), string.format("%.10g", a[9]['E']))
    assert.are.same(string.format("%.10g", e[9]['']),string.format("%.10g", a[9]['']))
    a[9]['E'], a[9][''], e[9]['E'], e[9][''] = nil, nil, nil, nil
    assert.are.same(e, a)

    assert.are.same(check('rapidjson/bin/jsonchecker/pass2.json', option))
    assert.are.same(check('rapidjson/bin/jsonchecker/pass3.json', option))
  end)

  it('should dump with pretty option = false', function()
    local option = {pretty=false}
    local e, a = check('rapidjson/bin/jsonchecker/pass1.json', option)
    assert.are.same(string.format("%.10g", e[9]['E']), string.format("%.10g", a[9]['E']))
    assert.are.same(string.format("%.10g", e[9]['']),string.format("%.10g", a[9]['']))
    a[9]['E'], a[9][''], e[9]['E'], e[9][''] = nil, nil, nil, nil
    assert.are.same(e, a)
    assert.are.same(check('rapidjson/bin/jsonchecker/pass2.json', option))
    assert.are.same(check('rapidjson/bin/jsonchecker/pass3.json', option))
  end)

  it('should dump with empty option', function()
    local option = {}
    local e, a = check('rapidjson/bin/jsonchecker/pass1.json', option)
    assert.are.same(string.format("%.10g", e[9]['E']), string.format("%.10g", a[9]['E']))
    assert.are.same(string.format("%.10g", e[9]['']),string.format("%.10g", a[9]['']))
    a[9]['E'], a[9][''], e[9]['E'], e[9][''] = nil, nil, nil, nil
    assert.are.same(e, a)

    assert.are.same(check('rapidjson/bin/jsonchecker/pass2.json', option))
    assert.are.same(check('rapidjson/bin/jsonchecker/pass3.json', option))
  end)

  it('should not dump with option other than table or nil', function()
    assert.has.errors(function()
      assert(json.dump({}, "dump.json", 1))
    end, [[bad argument #3 to 'dump' (table expected, got number)]])
  end)

  it('should raise error when filename is not string', function()
    assert.has.errors(function()
      assert(json.dump({}, nil, {}))
    end, [[bad argument #2 to 'dump' (string expected, got nil)]])
  end)

  local function get_file_content(filename)
    local f = io.open(filename)
    local contents = nil
    if f then
      contents = f:read("*a")
      f:close()
    end
    return contents
  end

  it('should handle utf-8 string', function()
    assert(json.dump({
    	["en"] = "I can eat glass and it doesn't hurt me.",
    	["zh-Hant"] = "我能吞下玻璃而不傷身體。",
    	["zh-Hans"] = "我能吞下玻璃而不伤身体。",
    	["ja"] = "私はガラスを食べられます。それは私を傷つけません。",
    	["ko"] = "나는 유리를 먹을 수 있어요. 그래도 아프지 않아요"
    }, "dump.json"))

    assert.are.equal(
      [[{"en":"I can eat glass and it doesn't hurt me.",]]..
      [["ja":"私はガラスを食べられます。それは私を傷つけません。",]]..
      [["ko":"나는 유리를 먹을 수 있어요. 그래도 아프지 않아요",]]..
      [["zh-Hans":"我能吞下玻璃而不伤身体。",]]..
      [["zh-Hant":"我能吞下玻璃而不傷身體。"}]],
      get_file_content("dump.json")
    )

  end)
end)
