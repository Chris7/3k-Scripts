mudlet = mudlet or {}; mudlet.mapper_script = true
if not tkm then
	tkm = {}
end

comTable = {}
dirtable = Set {"nw","n","ne","w","e","sw","s","se","u","d"}
fulldirtable = Set {"northwest", "north", "northeast", "west", "east", "southwest",
	"south", "southeast", "up", "down"}
dirtypes = {north=1, northeast=2, northwest=3, east=4, west=5,
	south=6, southeast=7, southwest=8, up=9, down=10, ["in"]=11, out=12}

dirnums = {[1]="north", [2]="northeast", [3]="northwest",[4]="east",
	[5]="west",[6]="south",[7]="southeast",[8]="southwest",[9]="up",[10]="down"}
tkm.specialChar = "Ã"
mapScale = 8
priorMapScale = 8
function calculateMapOffset()
	diroffset = {[1]={0,1*mapScale,0}, [2]={1*mapScale,1*mapScale,0}, 
		[3]={-1*mapScale,1*mapScale,0}, [4]={1*mapScale,0,0},
		[5]={-1*mapScale,0,0}, [6]={0,-1*mapScale,0}, 
		[7]={1*mapScale,-1*mapScale,0}, [8]={-1*mapScale,-1*mapScale,0},
		[9]={0,0,1}, [10]={0,0,-1}}
end
calculateMapOffset()

reversedir = {[1]=6, [2]=8, [3]=7,[4]=5,[5]=4,[6]=1,[7]=3,[8]=2,[9]=10,[10]=9}
speedwalking = nil
mapspecial = nil
