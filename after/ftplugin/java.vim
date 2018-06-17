function! SearchFileBackwards(fn)
    let fp = expand('%:p')
    let pos = len(fp) - 1
    while pos > 0
        let pom = ""
        if fp[pos] == '/'
            let pom = strpart(fp, 0, pos + 1) . a:fn
            if filereadable(pom)
                break
            endif
        endif
        let pos = pos - 1
    endwhile
    return pom
endfunction

function! BuildMavenProject()
    let pom = SearchFileBackwards("pom.xml")
    if pom != ""
        exec '!mvn -f '.SearchFileBackwards("pom.xml").' compile'
    else
        echohl WarningMsg | echo "No pom.xml found." | echohl None
    endif
endfunction

function! BuildGradleProject()
    let build_file = SearchFileBackwards("build.gradle")
    if build_file != ""
        exec '!gradle -b '.SearchFileBackwards("build.gradle").' classes'
    else
        echohl WarningMsg | echo "No build.gradle found." | echohl None
    endif
endfunction
" comment out below line to enable automatic build on maven project.
" autocmd BufWritePost *.java :call BuildMavenProject()

" Press <F7> to build current maven project.
" nnoremap <buffer> <silent> <F7> :call BuildMavenProject()<CR>
nnoremap <buffer> <silent> <F7> :call BuildGradleProject()<CR>
