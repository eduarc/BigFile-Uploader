<%-- 
    Document   : upload_form
    Created on : Feb 19, 2017, 5:38:21 PM
    Author     : eduarc
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>BLOB Upload</title>

        <script type="text/javascript">

            var file;
            var uploaded = 0;
            var fileSize = 0;
            var slices = 0;
            var sliceSize = 1 * 1024 * 1024; // 1MB
            var currentSlice = 0;

            function fileSelected() {

                var file = document.getElementById('file').files[0];
                if (file) {
                    var fileSize = 0;
                    if (file.size > 1024 * 1024)
                        fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
                    else
                        fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';

                    document.getElementById('fileName').innerHTML = 'Name: ' + file.name;
                    document.getElementById('fileSize').innerHTML = 'Size: ' + fileSize;
                    document.getElementById('fileType').innerHTML = 'Type: ' + file.type;
                }
            }

            function uploadSlice(slices, sliceSize, i, file) {

                var fd = new FormData();

                if (i + 1 < slices) {
                    fd.append("file", file.slice(i * sliceSize, (i + 1) * sliceSize));
                } else {
                    fd.append("file", file.slice(i * sliceSize));
                }
                fd.append("fileName", file.name);
                fd.append("fileType", file.type);
                fd.append("fileSize", file.size);
                fd.append("slice", i);

                var xhr = new XMLHttpRequest();
                xhr.upload.addEventListener("progress", uploadProgress, false);
                xhr.addEventListener("load", uploadComplete, false);
                xhr.addEventListener("error", uploadFailed, false);
                xhr.addEventListener("abort", uploadCanceled, false);
                xhr.open("POST", "upload", true);
                xhr.send(fd);
            }

            function uploadFile() {

                file = document.getElementById('file').files[0];
                uploaded = 0;
                currentSlice = 0;
                fileSize = file.size;
                slices = Math.floor(fileSize / sliceSize);
                
                if (fileSize % sliceSize !== 0) {
                    slices += 1;
                }
                document.getElementById('slice_progress').innerHTML = "# Slices " + slices;
                uploadSlice(slices, sliceSize, currentSlice, file);
            }

            function uploadProgress(evt) {
                
                var percentComplete = Math.round((uploaded + evt.loaded) * 100 / fileSize);
                percentComplete = Math.min(percentComplete, 100);
                document.getElementById('progressNumber').innerHTML = percentComplete.toString() + '%';
            }

            function uploadComplete(evt) {

                var now = document.getElementById('slice_progress').innerHTML;
                var add = evt.target.responseText;
                document.getElementById('slice_progress').innerHTML = now + add;

                if (currentSlice < slices - 1) {
                    uploaded += sliceSize;
                } else {
                    uploaded += fileSize % slices;
                }
                currentSlice++;
                if (currentSlice < slices) {
                    uploadSlice(slices, sliceSize, currentSlice, file);
                }
            }

            function uploadFailed(evt) {
                alert("There was an error attempting to upload the file.");
            }

            function uploadCanceled(evt) {
                alert("The upload has been canceled by the user or the browser dropped the connection.");
            }
        </script>
    </head>
    <form id="form1" enctype="multipart/form-data" method="post">
        <div class="row">
            <label for="file">Select a File to Upload</label><br />
            <input type="file" name="file" id="file" onchange="fileSelected();"/>
        </div>
        <div id="fileName"></div>
        <div id="fileSize"></div>
        <div id="fileType"></div>
        <div class="row">
            <input type="button" onclick="uploadFile()" value="upload" />
        </div>
        <div id="progressNumber"></div>
        <div id="slice_progress"></div>
    </form>
</html>
