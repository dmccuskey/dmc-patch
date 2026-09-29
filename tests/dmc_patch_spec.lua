--====================================================================--
-- tests/dmc_patch_spec.lua
--
-- Unit tests for dmc-patch, using Luna Test.
-- Run with tests/run_unit.sh
--
-- lua-patch has the full specs; these check the wrapper, and that
-- lua-patch's fixes come through it
--====================================================================--


module(..., package.seeall)



--====================================================================--
--== Setup


local Patch, LuaPatch

function suite_setup()
	Patch = require 'dmc_corona.dmc_patch'
	LuaPatch = require 'lib.dmc_lua.lua_patch'
end

-- each test starts and ends with every patch off
function setup() Patch.removePatch() end
function teardown() Patch.removePatch() end



--====================================================================--
--== Tests


function test_module()
	assert_equal( 'table', type( Patch ) )
	assert_equal( '0.2.0', Patch.VERSION )
	assert_equal( '0.4.0', Patch.__version )
	assert_equal( 'function', type( Patch.addPatch ) )
	assert_equal( 'string-format', Patch.PATCH_STRING_FORMAT )
end

function test_shared_module_untouched()
	assert_not_equal( LuaPatch, Patch )
	assert_nil( LuaPatch.VERSION )
	assert_equal( LuaPatch.addPatch, Patch.addPatch )
end

function test_no_global_extend()
	assert_nil( rawget( _G, '_extend' ) )
end

function test_quick_start()
	Patch.addAllPatches()
	assert_equal( "we rode 4 big horses", "we rode %s %s horses" % { 4, 'big' } )
	assert_equal( "http://server.com:9034/", "http://%s:%d/" % { 'server.com', 9034 } )
	local pending = { id_12='one', id_45='two' }
	assert_equal( 'one', table.pop( pending, 'id_12' ) )
	assert_nil( pending.id_12 )
	assert_function( pwarn )
	assert_function( pnotice )

	Patch.removePatch( 'string-format' )
	assert_nil( getmetatable( "" ).__mod )
	assert_function( table.pop )
end

function test_add_one_patch()
	Patch.addPatch( 'table-pop' )
	assert_function( table.pop )
	assert_nil( getmetatable( "" ).__mod )
	assert_nil( rawget( _G, 'pwarn' ) )
end

-- fixed in lua-patch 0.4.0; dmc-patch's README named it as a bug

function test_remove_all_patches()
	Patch.addAllPatches()
	Patch.removeAllPatches()
	assert_nil( table.pop )
	assert_nil( getmetatable( "" ).__mod )
	assert_nil( rawget( _G, 'pnotice' ) )
	assert_nil( rawget( _G, 'pwarn' ) )
end

function test_remove_patch_no_argument()
	Patch.addAllPatches()
	Patch.removePatch()
	assert_nil( table.pop )
	assert_nil( rawget( _G, 'pwarn' ) )
end

function test_unknown_patch_name()
	assert_error( function() Patch.addPatch( 'no-such-patch' ) end )
	assert_error( function() Patch.removePatch( 'no-such-patch' ) end )
end
