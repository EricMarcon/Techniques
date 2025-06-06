# Knit Rmd files
lapply(
  list.files(pattern = "*.qmd"),
  function(file) {
    quarto::quarto_render(file, output_format = "all")
  }
)
# Move files to docs/
# Parameters
destination <- "docs"
# Run
processed <- ""
if (!dir.exists(destination)) {
  dir.create(destination)
}
htmlFiles <- list.files(pattern = "*.html")
if (length(htmlFiles) > 0) {
  processed <- c(processed, htmlFiles)
  file.rename(
    from = htmlFiles,
    to = paste(destination, "/", htmlFiles, sep = "")
  )
}
cssFiles <- list.files(pattern = "*.css")
if (length(cssFiles) > 0) {
  processed <- c(processed, cssFiles)
  file.copy(
    from = cssFiles,
    to = paste(destination, "/", cssFiles, sep = ""),
    overwrite = TRUE
  )
}
html_filesDir <- list.files(pattern = "*_files")
if (length(html_filesDir) > 0) {
  processed <- c(processed, html_filesDir)
  vapply(
    paste(destination, "/", html_filesDir, sep = ""),
    FUN = dir.create,
    showWarnings = FALSE,
    FUN.VALUE = TRUE
  )
  # Rmd specific
  vapply(
    paste(destination, "/", html_filesDir, "/figure-html", sep = ""),
    FUN = dir.create,
    showWarnings = FALSE,
    FUN.VALUE = TRUE
  )
  html_files <- list.files(
    path = paste(html_filesDir, "/figure-html/", sep = ""),
    full.names = TRUE,
    recursive = TRUE
  )
  # Quarto specific
  vapply(
    paste(destination, "/", html_filesDir, "/libs", sep = ""),
    FUN = dir.create,
    showWarnings = FALSE,
    FUN.VALUE = TRUE
  )
  html_files <- list.files(
    path = paste(html_filesDir, "/libs/", sep = ""),
    full.names = TRUE,
    recursive = TRUE
  )
  if (length(html_files) > 0) {
    file.copy(
      from = html_files,
      to = paste(destination, "/", html_files, sep = ""),
      overwrite = TRUE
    )
  }
}
# Rmd specific
libsDirs <- list.dirs(path = "libs", full.names = TRUE, recursive = TRUE)
if (length(libsDirs) > 0) {
  processed <- c(processed, libsDirs)
  vapply(
    paste(destination, "/", libsDirs, sep = ""),
    FUN = dir.create,
    showWarnings = FALSE,
    FUN.VALUE = TRUE
  )
  libsFiles <- list.files("libs", full.names = TRUE, recursive = TRUE)
  file.copy(
    from = libsFiles,
    to = paste(destination, "/", libsFiles, sep = ""),
    overwrite = TRUE
  )
}
imagesDirs <- list.dirs(path = "images", full.names = TRUE, recursive = TRUE)
if (length(imagesDirs) > 0) {
  processed <- c(processed, imagesDirs)
  vapply(
    paste(destination, "/", imagesDirs, sep = ""),
    FUN = dir.create,
    showWarnings = FALSE,
    FUN.VALUE = TRUE
  )
  imagesFiles <- list.files("images", full.names = TRUE, recursive = TRUE)
  file.copy(
    from = imagesFiles,
    to = paste(destination, "/", imagesFiles, sep = ""),
    overwrite = TRUE
  )
}
# Rmd and qmd files
mdFiles <- c(
  list.files(pattern = "*.Rmd"),
  list.files(pattern = "*.qmd")
)
pdfFiles <- gsub(".Rmd", ".pdf", mdFiles)
if (length(pdfFiles) > 0) {
  processed <- c(processed, pdfFiles)
  suppressWarnings(
    file.rename(
      from = pdfFiles,
      to = paste(destination, "/", pdfFiles, sep = "")
    )
  )
}
PPTxFiles <- gsub(".Rmd", ".pptx", mdFiles)
if (length(PPTxFiles) > 0) {
  processed <- c(processed, PPTxFiles)
  suppressWarnings(
    file.rename(
      from = PPTxFiles,
      to = paste(destination, "/", PPTxFiles, sep = "")
    )
  )
}
docxFiles <- gsub(".Rmd", ".docx", mdFiles)
if (length(docxFiles) > 0) {
  processed <- c(processed, PPTxFiles)
  suppressWarnings(
    file.rename(
      from = docxFiles,
      to = paste(destination, "/", docxFiles, sep = "")
    )
  )
}
file.copy(from = "README.md", to = "docs/README.md", overwrite = TRUE)
processed <- c(processed, "README.md")
cat("Output files moved to", destination)
