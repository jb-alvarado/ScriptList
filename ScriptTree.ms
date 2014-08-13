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
-- ScriptTree v 1.0
-- Author: Jonathan Baecker (jb_alvarado) blog.pixelcrusher.de | www.pixelcrusher.de | www.animations-and-more.com
-- Createt: 2014-03-05
--
----------------------------------------------------------------------------------------------------------------------
*/
(
try ( destroyDialog ScriptTree )catch ()
	
	global iniFile = ( getDir #userScripts + @"\ScriptTree.ini" )
	global TreeNodeClass = dotnetclass "System.Windows.Forms.TreeNode"
	global cb = ( ( colorman.getColor #background )*255+20 ) as color
	global cf = ( ( colorman.getColor #text )*255+30 ) as color

	if not doesFileExist iniFile then (
		try ( new_ini = createFile iniFile ) catch ( messagebox ( "You have no write access to: \"" + iniFile + "\"..." ) title:"Script Tree" )
		format "[Paths]\n" to:new_ini
		close new_ini
		)

	fn get_all_scripts = (
		ScriptTree.tv.nodes.clear()
		global path01 = (getinisetting iniFile "Paths" "scriptDir_01")
		global path02 = (getinisetting iniFile "Paths" "scriptDir_02")
		global path03 = (getinisetting iniFile "Paths" "scriptDir_03")
		global path04 = (getinisetting iniFile "Paths" "scriptDir_04")

		global allFiles01 = #()
		global allFiles02 = #()
		global allFiles03 = #()
		global allFiles04 = #()
		global scriptFiles01 = #()
		global scriptFiles02 = #()
		global scriptFiles03 = #()
		global scriptFiles04 = #()
		
		if path01 != "" do for script01 in ( getFiles ( path01 + "\\*" ) ) do append allFiles01 script01
		if path02 != "" do for script02 in ( getFiles ( path02 + "\\*" ) ) do append allFiles02 script02
		if path03 != "" do for script03 in ( getFiles ( path03 + "\\*" ) ) do append allFiles03 script03
		if path04 != "" do for script04 in ( getFiles ( path04 + "\\*" ) ) do append allFiles04 script04

		if allFiles01.count > 0 do (
			for i = 1 to allFiles01.count do (
				if ( getFilenameType allFiles01[i] == ".ms" OR getFilenameType allFiles01[i] == ".mse" ) do (
					n01 = dotnetobject TreeNodeClass ( getFilenameFile allFiles01[i] )
					n01.tag = allFiles01[i]
					append scriptFiles01 n01
					)
				)
			flt01 = filterstring path01 "\\"
			dirName01 = flt01[flt01.count]
			t01 = dotnetobject TreeNodeClass dirName01
			t01.tag = path01
			t01.Nodes.AddRange scriptFiles01
			ScriptTree.tv.Nodes.Add t01
			t01.Expand()
			)
		
		if allFiles02.count > 0 do (
			for j = 1 to allFiles02.count do (
				if ( getFilenameType allFiles02[j] == ".ms" OR getFilenameType allFiles02[j] == ".mse" ) do (
					n02 = dotnetobject TreeNodeClass ( getFilenameFile allFiles02[j] )
					n02.tag = allFiles02[j]
					append scriptFiles02 n02
					)
				)
			flt02 = filterstring path02 "\\"
			dirName02 = flt02[flt02.count]
			t02 = dotnetobject TreeNodeClass dirName02
			t02.tag = path02
			t02.Nodes.AddRange scriptFiles02
			ScriptTree.tv.Nodes.Add t02
			)
		
		if allFiles03.count > 0 do (
			for k = 1 to allFiles03.count do (
				if ( getFilenameType allFiles03[k] == ".ms" OR getFilenameType allFiles03[k] == ".mse" ) do (
					n03 = dotnetobject TreeNodeClass ( getFilenameFile allFiles03[k] )
					n03.tag = allFiles03[k]
					append scriptFiles03 n03
					)
				)
			flt03 = filterstring path03 "\\"
			dirName03 = flt03[flt03.count]
			t03 = dotnetobject TreeNodeClass dirName03
			t03.tag = path03
			t03.Nodes.AddRange scriptFiles03
			ScriptTree.tv.Nodes.Add t03
			)

		if allFiles04.count > 0 do (
			for l = 1 to allFiles04.count do (
				if ( getFilenameType allFiles04[l] == ".ms" OR getFilenameType allFiles04[l] == ".mse" ) do (
					n04 = dotnetobject TreeNodeClass ( getFilenameFile allFiles04[l] )
					n04.tag = allFiles04[l]
					append scriptFiles04 n04
					)
				)
			flt04 = filterstring path04 "\\"
			dirName04 = flt04[flt04.count]
			t04 = dotnetobject TreeNodeClass dirName04
			t04.tag = path04
			t04.Nodes.AddRange scriptFiles04
			ScriptTree.tv.Nodes.Add t04
			)
			
		--ScriptTree.tv.expandAll()
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
			get_all_scripts()
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
			
	rollout ScriptTree "Script Tree" width:200 height:265 (
		
		groupBox grpList "Collection From All Scripts:" pos:[5,5] width:190 height:255
			dotNetControl tv "system.windows.forms.treeView" pos:[15,25] width:170 height:210
			button btn "Configure" pos:[170,240] width:15 height:15 images:#("crwd_pick_i.bmp", "crwd_pick_a.bmp", 2,1,2,1,1)

		on btn pressed do (
			createDialog Configure style:#(#style_toolwindow, #style_border, #style_sysmenu)
			)
			
		-----------------------------------------------
		--resize statment
		-----------------------------------------------
		on ScriptTree resized newSize do (
			grpList.width=newSize[1]-10
			grpList.height=newSize[2]-10
				tv.width=newSize[1]-30
				tv.height=newSize[2]-55
				btn.pos=[newSize[1]-30,newSize[2]-25]
			)

		struct tv_context_menu (
			fn RunScript sender arg = (
				No = sender.Parent.SourceControl
				if getFilenameType No.SelectedNode.tag == ".mse" OR getFilenameType No.SelectedNode.tag == ".ms" do (
					fileIn No.SelectedNode.tag
					)
				),	
			fn null = (),
			fn EditScript sender arg = (
				No = sender.Parent.SourceControl
				edit No.SelectedNode.tag
				),
			fn CreateScript sender arg = (
				No = sender.Parent.SourceControl

				if No.SelectedNode != undefined then (
					createF = No.SelectedNode.tag + @"\"
					) else (
						createF = getDir #userScripts + @"\"
						)
						
				saveFile = getSaveFileName \
				caption:"Create new Script File" \
				filename:createF \
				types:"Script File (*.ms)|*.ms|" \
				historyCategory:"Scripts"
				
				if (saveFile != undefined) do (
					file = createFile saveFile
					close file
					edit saveFile
					get_all_scripts()
					)
				),
			fn RefreshList sender arg = (
				get_all_scripts()
				),
			fn OpenInExplorer sender arg = (
				No = sender.Parent.SourceControl
				
				if getFilenameType No.SelectedNode.tag == ".mse" OR getFilenameType No.SelectedNode.tag == ".ms" then (
					ShellLaunch "explorer.exe" ( "/e,/select," + No.SelectedNode.tag )
					) else if doesFileExist No.SelectedNode.tag then (
						ShellLaunch "explorer.exe" No.SelectedNode.tag
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
			
		on ScriptTree open do (
			tv.BackColor = ( dotNetClass "System.Drawing.Color" ).fromARGB cb.r cb.g cb.b
			tv.ForeColor = ( dotNetClass "System.Drawing.Color" ).fromARGB cf.r cf.g cf.b
			tv.allowdrop = true			
			get_all_scripts()
			)
		
		
		on tv MouseDoubleClick arg do (
			try ( fileIn (tv.GetNodeAt arg.location).tag ) catch ( print "Something is wrong with the script" )
			)
				
		--these flags keep me from dropping stuff back onto the treelist
		local dragFlag = false
		on tv itemDrag sender args do dragFlag = true
		on tv mouseUp sender args do (
			dragFlag = false
			hit=( tv.HitTest ( dotNetObject "System.Drawing.Point" args.x args.y ) )

			if hit.Node != undefined do (
				if ( getFilenameType (tv.GetNodeAt args.location).tag == ".mse" ) then (
					ext = "mse"
					) else if ( getFilenameType (tv.GetNodeAt args.location).tag == ".ms" ) then (
						ext = "ms"
						)
				)

			cm = tv_context_menu()
			tv.ContextMenu = cm.getmenu( ext )
			)
			
		--When the treeview loses focus, activate the drag/drop menu
		on tv lostFocus sender args do if dragFlag == true do (
			try ( fileIn sender.SelectedNode.tag ) catch ()
			)    
		
	)	

	createDialog ScriptTree style:#(#style_toolwindow, #style_border, #style_sysmenu, #style_resizing)
	cui.RegisterDialogBar ScriptTree minSize:[150, 100] maxSize:[-1, 1200] style:#(#cui_dock_vert, #cui_floatable, #cui_handles)
)
