post_message "############################################################################################"
post_message "## Archive_project starts..."
post_message "############################################################################################"

# #################################################################################################################################
# #################################################################################################################################
# Edit variables below to customize behavior of auto backup
# #################################################################################################################################

# Enable (1) / Disable (0) overwrite of filepaths in QSF file.
set enable_qsf_overwrite 0

#Here set full path to zip executable
set 7zip_path "C:\\Program Files\\7-Zip"
set zipexe [file join $7zip_path "7z.exe"]

# Temporary folder.
set temp_folder "C:/ap_tmp"

# Enable (1) / Disable (0) overwrite of read-only files
set overwrite_ro 1

# #################################################################################################################################
# #################################################################################################################################
# #################################################################################################################################
proc qarlog_to_file_list {filename} {
    list file_list []
    set flag0 0
    
    set fid [open $filename r]
    
    while {[gets $fid line] >= 0} {
        if {             $flag0==0 && [string match "*=========== Files Selected: ===========*"     $line]==1} {set flag0 1; continue}
        if {$flag0==1 &&              [string match "*======= Total: * files to archive =======*"   $line]==1} {             break}
        
        if {$flag0==1} {
            lappend file_list [string trim $line]
        }
    }
    
    close $fid
    
    return $file_list
}

proc create_file_from_list {filename list} {
    set fid [open $filename w]
    
    foreach l $list {
        puts $fid "$l"
    }
    
    close $fid
}

proc create_svn_add_batch {filename_bat filename_list} {
    set fid [open $filename_bat w]
    
    puts $fid "svn add --force --parents --targets $filename_list"
    puts $fid "pause"
    
    close $fid
}
# #################################################################################################################################
# #################################################################################################################################
# #################################################################################################################################

# Directory used to store zipped projects
set bkp_directory      "archived_projects"

global quartus

if ![is_project_open] {
    # No project openned => suppose run from command line.
    set project [lindex $quartus(args) 1]
    set revision [lindex $quartus(args) 2]
    project_open -revision $revision $project
    set need_close 1
} else {
    set revision [get_current_revision]
    cd [get_project_directory]
    set need_close 0
}

# Temporary .qar name
set qar_name        "archive_$revision"

# Create QAR
if { [catch {
    project_archive -use_file_set custom -use_file_subset {qsf auto out rpt} $qar_name.qar -overwrite
    if {$need_close} {project_close}
} res ] } {
    post_message -type warning $res
    post_message -type warning "## $qar_name.qar cannot be created."
} else {
    post_message "## Successfully archived project $qar_name.qar"
}

# Generates a name for the qar based on the name of the revision
# and the current time.
proc generateTimedName { revision } {

    # The name of the qar is based on the revision name and the time
    set time_stamp [clock format [clock seconds] -format {%Y%m%d-%H%M%S}]
    return $revision-$time_stamp
}

# Directory and file name
set timed_name          [generateTimedName $revision]
set full_directory      [file join $bkp_directory $revision]
set file_common_name    $revision
set full_path           [file join $full_directory $file_common_name]

set time_stamp          [clock format [clock seconds] -format {%H%M%S}]
set temp_root           [file join $temp_folder $time_stamp]
set temp_name           [file join $temp_root $file_common_name]

# Create archive directory
if { [catch {

    file mkdir $bkp_directory

} res ] } {
    post_message -type warning $res
    post_message -type warning "## Cannot create archive directory $bkp_directory, exiting Archive_project."
    return -1
} else {
    post_message "## Successfully created archive directory $bkp_directory, continuing Archive_project..."
}


# Create temporary backup directory
if { [catch {

    file mkdir $temp_root

} res ] } {
    post_message -type warning $res
    post_message -type warning "## Cannot create backup directories $temp_root, exiting incremental backup."
    return -1
} else {
    post_message "## Successfully created backup directories $temp_root, continuing incremental backup..."
}

# Restore projects
if { [catch {
    if { $enable_qsf_overwrite } {
        project_restore $qar_name.qar -destination $temp_name -overwrite -update_included_file_info
    } else {
        project_restore $qar_name.qar -destination $temp_name -overwrite
    }
} res ] } {
    post_message -type warning $res
    post_message -type warning "## Problem while restoring archived project, exiting Archive_project."
    return -1
} else {

}

# Create SVN helper.
if { [catch {
    create_file_from_list "$qar_name.filelist" [qarlog_to_file_list $qar_name.qarlog]
    create_svn_add_batch "${qar_name}_add_svn.bat" "$qar_name.filelist"
} res ] } {
    post_message -type warning $res
    post_message -type warning "## Unable to create SVN helper."
    return -1
} else {
    
}

# Delete temporary .qar files
if { [catch {
    file delete $qar_name.qar
    # file delete $qar_name.qarlog
} res ] } {
    post_message -type warning $res
    post_message -type warning "## Problem while deleting temporary .qar ($qar_name.*), exiting Archive_project."
    return -1
} else {
    
}

# Create .zip
if { [catch {       
        cd $bkp_directory
        if {[file exists "$file_common_name.zip"]} {
            if {$overwrite_ro} {file attribute $file_common_name.zip -readonly 0}
            file delete -force $file_common_name.zip
        }
        file delete -force [file join $temp_name "qar_info.json"]
        exec $zipexe a $file_common_name.zip $temp_name
        file copy -force $file_common_name.zip $timed_name.zip
        file delete -force $temp_name
        file delete -force $temp_root
} res ] } {
    post_message -type warning "## Problem while creating .zip file."
    return -code error $res
} else {
    post_message "## Successfully processing Archive_project."
}

post_message "############################################################################################"
post_message "## Archive_project ends."
post_message "############################################################################################"


