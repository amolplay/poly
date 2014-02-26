class CommentsController < ApplicationController

  #respond_to :html, :xml, :json
  #before_filter :load_commentable

  def index
    @commentable = find_commentable
    @comments = @commentable.comments

  end

  def new

    @comment = @commentable.comments.new

  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
      return $1.classify.constantize.find(value)
      end
    end
    nil

  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
     @comment.user_id = current_user.id
    if @comment.save
      flash[:notice] = "Successfully saved comment."
      redirect_to @commentable  
    else
      #render 'new'
      redirect_to @commentable, :flash => { :error => "Comment body can not be blank " }
    end

  end


  def edit
    @commentable = find_commentable
    @comment = @commentable.comments.find(params[:id])
  end

  def update
    
    @commentable = find_commentable
    @comment = @commentable.comments.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to(@commentable, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end





  def destroy
    @comment = Comment.find(params[:id])
    
    @commentable = find_commentable
    @comments = @commentable.comments

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @commentable  }
      format.json { head :no_content }
    end
  end
 



  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def comment_params
    params.require(:comment).permit(:content,:user_id)
  end

end
