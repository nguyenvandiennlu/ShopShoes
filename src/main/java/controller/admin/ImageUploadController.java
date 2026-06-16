package controller.admin;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import utils.CloudinaryUtil;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

@WebServlet("/admin/upload-image")
@MultipartConfig(
        maxFileSize    = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class ImageUploadController extends HttpServlet {

    private static final Gson gson = new Gson();

    private static final java.util.Set<String> ALLOWED_TYPES = java.util.Set.of(
            "image/jpeg", "image/png", "image/webp", "image/gif"
    );

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        try {
            Part filePart = req.getPart("file");

            if (filePart == null || filePart.getSize() == 0) {
                badRequest(res, "Không có file được gửi lên."); return;
            }

            String contentType = filePart.getContentType();
            if (contentType == null || !ALLOWED_TYPES.contains(contentType.toLowerCase())) {
                badRequest(res, "Chỉ chấp nhận file ảnh (JPEG, PNG, WebP, GIF)."); return;
            }

            String folder = req.getParameter("folder");
            if (folder == null || folder.isBlank()) folder = "products";

            Cloudinary cloudinary = CloudinaryUtil.getInstance();

            try (InputStream is = filePart.getInputStream()) {
                byte[] bytes = is.readAllBytes();

                @SuppressWarnings("unchecked")
                Map<String, Object> uploadResult = cloudinary.uploader().upload(
                        bytes,
                        ObjectUtils.asMap(
                                "folder",          folder,
                                "resource_type",   "image",
                                "use_filename",    false,
                                "unique_filename", true
                        )
                );

                String secureUrl = (String) uploadResult.get("secure_url");
                String publicId  = (String) uploadResult.get("public_id");

                res.getWriter().write(gson.toJson(Map.of(
                        "success",   true,
                        "url",       secureUrl,
                        "publicId",  publicId
                )));
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.getWriter().write("{\"error\":\"Upload thất bại. Vui lòng thử lại.\"}");
        }
    }

    private void badRequest(HttpServletResponse res, String msg) throws IOException {
        res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        res.getWriter().write("{\"error\":\"" + msg + "\"}");
    }
}