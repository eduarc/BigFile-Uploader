/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author eduarc
 */
@WebServlet(name = "Upload", urlPatterns = {"/upload"})
@MultipartConfig
public class Upload extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        ServletContext context = getServletContext();
        RequestDispatcher dispatcher = context.getRequestDispatcher("/WEB-INF/upload/upload_form.jsp");
        try {
            dispatcher.forward(request, response);
        } catch (ServletException | IOException ex) {
            log(ex.getMessage());
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        
        String slice = request.getParameter("slice");
        String fileName = request.getParameter("fileName");
        String fileType = request.getParameter("fileType");
        int fileSize = Integer.parseInt(request.getParameter("fileSize"));
        Part filePart = request.getPart("file");

        if (slice.equals("0")) {
            System.out.println("File Name: " + fileName);
            System.out.println("File Type: " + fileType);
            System.out.println("File Size: " + fileSize);
        }
        System.out.println("Slice-" + slice + " Size: " + filePart.getSize());
        
        try (OutputStream out = new FileOutputStream(new File(fileName), true);
            InputStream fileContent = filePart.getInputStream()) {
            int read;
            byte[] bytes = new byte[fileSize];
            while ((read = fileContent.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
        }
        try (PrintWriter writer = response.getWriter()) {
            writer.print("<p>Slice " + slice + " uploaded</p>");
        }
    }
}
