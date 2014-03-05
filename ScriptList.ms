/*
----------------------------------------------------------------------------------------------------------------------
::
:: Description: This MaxScript list all scripts in a specified folder.
::
----------------------------------------------------------------------------------------------------------------------
:: LICENSE ----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
::
:: Copyright (C) 2014 Jonathan Baecker (jb_alvarado)
::
:: This program is free software: you can redistribute it and/or modify
:: it under the terms of the GNU General Public License as published by
:: the Free Software Foundation, either version 3 of the License, or
:: (at your option) any later version.
::
:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
:: GNU General Public License for more details.
::
:: You should have received a copy of the GNU General Public License
:: along with this program. If not, see <http://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
:: History --------------------------------------------------------------------------------------------------------
:: 2014-01-22 start script
:: 2014-01-23 create rightclick menu ( help from here: http://forums.cgsociety.org/showthread.php?p=7740188 )
:: 2014-01-24 add dock window function
:: 2014-01-25 add more functions
:: 2014-01-29 add mse scripts to the list
:: 2014-01-30 better rightclick menu
:: 2014-03-04 add ini file, add configure dialog for adding script paths, now also more paths is allow
::
----------------------------------------------------------------------------------------------------------------------
::
::
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
--
-- ScriptList v 1.0
-- Author: Jonathan Baecker (jb_alvarado) blog.pixelcrusher.de | www.pixelcrusher.de
-- Createt: 2014-01-22
--
----------------------------------------------------------------------------------------------------------------------
*/
(
try ( destroyDialog ScriptList )catch ()
	
	global iniFile = ( getDir #userScripts + @"\ScriptList.ini" )

	if not doesFileExist iniFile then (
		try ( new_ini = createFile iniFile ) catch ( messagebox ( "You have no write access to: \"" + iniFile + "\"..." ) title:"Script List" )
		format "[Paths]\n" to:new_ini
		close new_ini
		)

	fn get_all_scripts = (
		global path01 = (getinisetting iniFile "Paths" "scriptDir_01")
		global path02 = (getinisetting iniFile "Paths" "scriptDir_02")
		global path03 = (getinisetting iniFile "Paths" "scriptDir_03")
		global path04 = (getinisetting iniFile "Paths" "scriptDir_04")

		global allFiles = #()
		global scriptFiles = #()

		if path01 != "" do for script in ( getFiles ( path01 + "\\*" ) ) do append allFiles script
		if path02 != "" do for script in ( getFiles ( path02 + "\\*" ) ) do appendIfUnique allFiles script
		if path03 != "" do for script in ( getFiles ( path03 + "\\*" ) ) do appendIfUnique allFiles script
		if path04 != "" do for script in ( getFiles ( path04 + "\\*" ) ) do appendIfUnique allFiles script
		
		for i = 1 to allFiles.count do (
			if ( getFilenameType allFiles[i] == ".ms" OR getFilenameType allFiles[i] == ".mse" ) do (
				append scriptFiles allFiles[i]
				)
			)
		)
		
	fn buildList path01 = (
		ScriptList.mlbxList.clear()
		ScriptList.mlbxList.HeaderStyle = none
		ScriptList.mlbxList.columns.add "Scripts" 216
		ScriptList.mlbxList.view = (dotNetClass "system.windows.forms.view").details
		ScriptList.mlbxList.FullRowSelect = true
		ScriptList.mlbxList.GridLines = false
		ScriptList.mlbxList.MultiSelect = false
		ScriptList.mlbxList.allowdrop = true
		cb = ((colorman.getColor #background)*255+20) as color
		ScriptList.mlbxList.BackColor = (dotNetClass "System.Drawing.Color").fromARGB cb.r cb.g cb.b
		cf = ((colorman.getColor #text)*255+30) as color
		ScriptList.mlbxList.ForeColor = (dotNetClass "System.Drawing.Color").fromARGB cf.r cf.g cf.b
		get_all_scripts()
		ScriptList.mlbxList.columns.item[0].width = ScriptList.width-34
		all_files = #()
		
		for i = 1 to scriptFiles.count do (
			li = dotNetObject "System.Windows.Forms.ListViewItem" (getFilenameFile scriptFiles[i] as string)
			li.UseItemStyleForSubItems=true
			colAdd=cb.r+(if ( mod i 2 )==0 then -20 else 20)
			li.BackColor=li.backcolor.fromARGB colAdd colAdd colAdd
			
			append all_files li 
			)
		
		ScriptList.mlbxList.items.addRange all_files
		ScriptList.mlbxList.Update()
		)	
	
	rollout configure "Script List Configure" width:180 height:115 (

		groupBox grpList "Configure Paths:" pos:[5,5] width:170 height:100
			editText edtpath1 "" pos:[10,20] width:140
			button btnP1 "Path1" pos:[155,20] width:16 height:16 images:#("bip_mixerio_i.bmp", "bip_mixerio_i.bmp", 4,1,2,1,1)
			editText edtpath2 "" pos:[10,40] width:140
			button btnP2 "Path1" pos:[155,40] width:16 height:16 images:#("bip_mixerio_i.bmp", "bip_mixerio_i.bmp", 4,1,2,1,1)
			editText edtpath3 "" pos:[10,60] width:140
			button btnP3 "Path1" pos:[155,60] width:16 height:16 images:#("bip_mixerio_i.bmp", "bip_mixerio_i.bmp", 4,1,2,1,1)
			editText edtpath4 "" pos:[10,80] width:140
			button btnP4 "Path1" pos:[155,80] width:16 height:16 images:#("bip_mixerio_i.bmp", "bip_mixerio_i.bmp", 4,1,2,1,1)
		
		on configure open do (
			if doesFileExist iniFile do (
				edtpath1.text =	( getinisetting iniFile "Paths" "scriptDir_01" )
				edtpath2.text =	( getinisetting iniFile "Paths" "scriptDir_02" )
				edtpath3.text =	( getinisetting iniFile "Paths" "scriptDir_03" )
				edtpath4.text =	( getinisetting iniFile "Paths" "scriptDir_04" )
				)
			)
		
		on configure close do (
			buildList path01
			)
			
		on edtpath1 entered input do (
			setINISetting iniFile "Paths" "scriptDir_01" input
			)
		
		on edtpath2 entered input do (
			setINISetting iniFile "Paths" "scriptDir_02" input
			)
			
		on edtpath3 entered input do (
			setINISetting iniFile "Paths" "scriptDir_03" input
			)

		on edtpath4 entered input do (
			setINISetting iniFile "Paths" "scriptDir_04" input
			)
	
		on btnP1 pressed do (
			folder1 = getSavePath caption:"Select Path:" initialDir:( getDir #userScripts )
			if folder1 != undefined then (
				edtpath1.text = folder1
				setINISetting iniFile "Paths" "scriptDir_01" folder1
				) else (
					edtpath1.text = ""
					setINISetting iniFile "Paths" "scriptDir_01" ""
					)
			)
		
		on btnP2 pressed do (
			folder2 = getSavePath caption:"Select Path:" initialDir:( getDir #userScripts )
			if folder2 != undefined then (
				edtpath2.text = folder2
				setINISetting iniFile "Paths" "scriptDir_02" folder2
				) else (
					edtpath2.text = ""
					setINISetting iniFile "Paths" "scriptDir_02" ""
					)
			)

		on btnP3 pressed do (
			folder3 = getSavePath caption:"Select Path:" initialDir:( getDir #userScripts )
			if folder3 != undefined then (
				edtpath3.text = folder3
				setINISetting iniFile "Paths" "scriptDir_03" folder3
				) else (
					edtpath3.text = ""
					setINISetting iniFile "Paths" "scriptDir_03" ""
					)
			)
			
		on btnP4 pressed do (
			folder4 = getSavePath caption:"Select Path:" initialDir:( getDir #userScripts )
			if folder4 != undefined then (
				edtpath4.text = folder4
				setINISetting iniFile "Paths" "scriptDir_04" folder4
				) else (
					edtpath4.text = ""
					setINISetting iniFile "Paths" "scriptDir_04" ""
					)
			)
		
		)
			
	rollout ScriptList "Script List" width:200 height:265 (
		
		groupBox grpList "Collection From All Scripts:" pos:[5,5] width:190 height:255
			dotNetControl mlbxList "system.windows.forms.listView" pos:[15,25] width:170 height:210
			button btn "Configure" pos:[170,240] width:15 height:15 images:#("crwd_pick_i.bmp", "crwd_pick_a.bmp", 2,1,2,1,1)

		on btn pressed do (
			createDialog Configure style:#(#style_toolwindow, #style_border, #style_sysmenu)
			)
			
		-----------------------------------------------
		--resize statment
		-----------------------------------------------
		on ScriptList resized newSize do (
			grpList.width=newSize[1]-10
			grpList.height=newSize[2]-10
				mlbxList.width=newSize[1]-30
				mlbxList.height=newSize[2]-55
				btn.pos=[newSize[1]-30,newSize[2]-25]
			
				try ( mlbxList.columns.item[0].width = newSize[1]-34 ) catch ()
			)

		struct lv_context_menu (
			fn RunScript sender arg = (	
				lv = sender.Parent.SourceControl -- gets you the access to the dotnet control
				index = lv.SelectedItems.Item[0].index + 1
				fileIn scriptFiles[index]
				),	
			fn null = (),
			fn EditScript sender arg = (	
				lv = sender.Parent.SourceControl
				index = lv.SelectedItems.Item[0].index + 1
				edit scriptFiles[index]
				),
			fn CreateScript sender arg = (	
				saveFile = getSaveFileName \
				caption:"Create new Script File" \
				filename:( path01 + @"\" ) \
				types:"Script File (*.ms)|*.ms|" \
				historyCategory:"Scripts"

				if (saveFile != undefined) do (
					file = createFile saveFile
					close file
					edit saveFile
					scriptFiles = #()
					buildList path01
					)
				),
			fn RefreshList sender arg = (
				scriptFiles = #()
				buildList path01
				),
			fn OpenInExplorer sender arg = (
				lv = sender.Parent.SourceControl
				try (
					index = lv.SelectedItems.Item[0].index + 1
					ShellLaunch "explorer.exe" ( "/e,/select," + scriptFiles[index] )
					) catch (
						ShellLaunch "explorer.exe" path01
						)
				),
			names = #( "&Run Script","-", "&Edit Script", "&New Script", "&Refresh List", "-", "&Open Path" ),
			eventHandlers = #( RunScript, null, EditScript, CreateScript, RefreshList,  null, OpenInExplorer ),	
			events = #( "Click", "Click", "Click", "Click", "Click", "Click", "Click" ),
			
			fn GetMenu ext = (
				cm = ( dotNetObject "System.Windows.Forms.ContextMenu" )
				for i = 1 to names.count do (
					mi = cm.MenuItems.Add names[i]
					
					if ext == "mse" AND names[i] == "&Edit Script" then (
						mi.enabled = off
						) else if (	ext != "mse" AND ext != "ms" ) then (
							if names[i] == "&Run Script" OR names[i] == "&Edit Script" do (
								mi.enabled = off
								)
							)
	
					dotNet.addEventHandler  mi events[i] eventHandlers[i]
					dotNet.setLifetimeControl mi #dotnet
					)	
				cm
				)
			)
			
		on ScriptList open do (
			buildList path01
			)

		on mlbxList MouseDoubleClick arg do (
			hit=( mlbxList.HitTest ( dotNetObject "System.Drawing.Point" arg.x arg.y ) )
			all_files=hit.item.Index
			index = mlbxList.items.item[all_files].index + 1
			try ( fileIn scriptFiles[index] ) catch ( print "Something is wrong with the script" )
			)
				
		--these flags keep me from dropping stuff back onto the treelist
		local dragFlag = false
		on mlbxList itemDrag sender args do dragFlag = true
		on mlbxList mouseUp sender args do (
			dragFlag = false
			hit=( mlbxList.HitTest ( dotNetObject "System.Drawing.Point" args.x args.y ) )
			
			if hit.item != undefined do (
				all_files=hit.item.Index
				index = mlbxList.items.item[all_files].index + 1
				
				if ( getFilenameType scriptFiles[index] == ".mse" ) then (
					ext = "mse"
					) else if ( getFilenameType scriptFiles[index] == ".ms" ) then (
						ext = "ms"
						)
				)

			cm = lv_context_menu()
			mlbxList.ContextMenu = cm.getmenu( ext )
			)
			
		--When the treeview loses focus, activate the drag/drop menu
		on mlbxList lostFocus sender args do if dragFlag == true do (			
			local theIndex = sender.SelectedItems.Item[0].index + 1
			cursors = dotNetClass "System.Windows.Forms.Cursors"
			cursor = dotNetClass "System.Windows.Forms.Cursor"
			cursor.current = cursors.hand

			try ( fileIn scriptFiles[theIndex] ) catch ()
			)    
		)

	createDialog ScriptList style:#(#style_toolwindow, #style_border, #style_sysmenu, #style_resizing)
	cui.RegisterDialogBar ScriptList minSize:[150, 100] maxSize:[-1, 1200] style:#(#cui_dock_vert, #cui_floatable, #cui_handles)
)