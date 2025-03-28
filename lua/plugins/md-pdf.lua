return {
  "arminveres/md-pdf.nvim",
  config = function()
    keys = {
      "<leader>qp",
      function()
        require("md-pdf").convert_md_to_pdf()
      end,
    }
  end,
}
