function (data, datatype, hypothesis, deletion) {

    if (ncol(hypothesis) != 5) {
        stop('The hypothesis matrix has the wrong number of columns.')
    }

    if (NA %in% hypothesis) {
        stop("The hypothesis matrix has a missing element.")
    } else if (!is.numeric(hypothesis)) {
        stop('The hypothesis matrix has a non-numeric element.')
    } else if (!all(abs(hypothesis[,5]) <= 1)) {
        stop('The hypothesis matrix has a fixed value that is less than -1 or greater than 1.')
    } else if (!all(hypothesis[,1:4] %% 1 == 0)) {
        stop('The hypothesis matrix has a non-integer where it shouldn\'t.')
    } else if (!all(hypothesis[,1:4] > 0)) {
        stop('The hypothesis matrix has a negative or zero number where it shouldn\'t.')
    } else if (!all(hypothesis[,1] == 1)) {
        stop('The hypothesis matrix references a non-existent group.')
    }

    for (i in 1:nrow(hypothesis)) {
        variables <- ncol(data)
        row.index <- hypothesis[i,2]
        col.index <- hypothesis[i,3]
        if (row.index > variables) {
            stop('The hypothesis matrix references a non-existent variable.')
        } else if (col.index > variables) {
            stop('The hypothesis matrix references a non-existent variable.')
        }
    }

    rows <- nrow(data)
    cols <- ncol(data)

    if (datatype == "rawdata") {

        if (rows <= cols) {
            stop("A raw data matrix must have more participants than variables.")
        }

        if (deletion == "pairwise") {
            R <- cor(data, use="pairwise")
            if (NA %in% R) {
                stop("There is too much missing data to use pairwise deletion.")
            }
        }

        if (deletion == "nodeletion") {

            if (NA %in% data) {
                stop('Data matrix has at least one empty entry.')
            }

            if (!is.numeric(data)) {
                stop("Data matrix has at least one non-numeric entry.")
            }
        }
    }


    if (datatype == 'correlation') {

        if (!all(abs(data) <= 1)) {
            stop('Correlation matrix has a value that is less than -1 or greater than 1.')
        }

        if (rows != cols) {
            stop('Correlation matrix is not square.')
        }
    }
}