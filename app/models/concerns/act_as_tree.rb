module ActAsTree
  extend ActiveSupport::Concern

  included do
    extend TreeWalker

    belongs_to :parent, class_name: name,
      primary_key: :id,
      foreign_key: :parent_id,
      optional: true

    has_many :children,
      class_name: name,
      primary_key: :id,
      foreign_key: :parent_id,
      dependent: :destroy,
      inverse_of: :parent

    # Returns a hash of all nodes grouped by their level in the tree structure.
    #
    # Class.generations # => { 0=> [root1, root2], 1=> [root1child1, root1child2, root2child1, root2child2] }
    scope :generation, ->{all.group_by(&:tree_level)}
    scope :roots, ->{where parent_id: nil}
    scope :leaves,
      ->{where("id NOT IN (#{select(:parent_id).where(arel_table[:parent_id].not_eq(nil)).to_sql})")}
    scope :all_but_self_and_descendants,
      ->(tree){where("id NOT IN (#{tree.self_and_descendants.map(&:id).join(',')})")}
  end

  class_methods do
    def root
      roots.first
    end
  end

  # Returns list of ancestors, starting from parent until root.
  #
  #   subchild1.ancestors # => [child1, root]
  def ancestors
    node = self
    nodes = []
    nodes << node = node.parent while node.parent
    nodes
  end

  # Returns list of descendants, starting from current node, not including current node.
  #
  #   root.descendants # => [child1, child2, subchild1, subchild2, subchild3, subchild4]
  def descendants
    children.each_with_object(children.to_a) do |child, arr|
      arr.concat child.descendants
    end.uniq
  end

  # Returns list of descendants, starting from current node, including current node.
  #
  #   root.self_and_descendants # => [root, child1, child2, subchild1, subchild2, subchild3, subchild4]
  def self_and_descendants
    [self] + descendants
  end

  # Returns the root node of the tree.
  def root
    node = self
    node = node.parent while node.parent
    node
  end

  # Returns all siblings of the current node.
  #
  #   subchild1.siblings # => [subchild2]
  def siblings
    self_and_siblings - [self]
  end

  # Returns all siblings and a reference to the current node.
  #
  #   subchild1.self_and_siblings # => [subchild1, subchild2]
  def self_and_siblings
    parent ? parent.children : self.class.roots
  end

  # Returns all the nodes at the same level in the tree as the current node.
  #
  #  root1child1.generation # => [root1child2, root2child1, root2child2]
  def generation
    self_and_generation - [self]
  end

  # Returns a reference to the current node and all the nodes at the same level as it in the tree.
  #
  #  root1child1.self_and_generation # => [root1child1, root1child2, root2child1, root2child2]
  def self_and_generation
    self.class.select{|node| node.tree_level == tree_level}
  end

  # Returns the level (depth) of the current node
  #
  #  root1child1.tree_level # => 1
  def tree_level
    ancestors.size
  end

  # Returns the level (depth) of the current node unless level is a column on the node.
  # Allows backwards compatibility with older versions of the gem.
  # Allows integration with apps using level as a column name.
  #
  #  root1child1.level # => 1
  def level
    if self.class.column_names.include?("level")
      super
    else
      tree_level
    end
  end

  # Returns children (without subchildren) and current node itself.
  #
  #   root.self_and_children # => [root, child1]
  def self_and_children
    [self] + children
  end

  # Returns ancestors and current node itself.
  #
  #   subchild1.self_and_ancestors # => [subchild1, child1, root]
  def self_and_ancestors
    [self] + ancestors
  end

  # Returns true if node has no parent, false otherwise
  #
  #   subchild1.root? # => false
  #   root.root?      # => true
  def root?
    parent.nil?
  end

  # Returns true if node has no children, false otherwise
  #
  #   subchild1.leaf? # => true
  #   child1.leaf?    # => false
  def leaf?
    children.size.zero?
  end

  module TreeWalker
    # Traverse the tree and call a block with the current node and current
    # depth-level.
    #
    # options:
    #   algorithm:
    #     :dfs for depth-first search (default)
    #     :bfs for breadth-first search
    #   where: AR where statement to filter certain nodes
    #
    # The given block sets two parameters:
    #   first: The current node
    #   second: The current depth-level within the tree
    #
    # Example of acts_as_tree for model Page (ERB view):
    # <% Page.walk_tree do |page, level| %>
    #   <%= link_to "#{' '*level}#{page.name}", page_path(page) %><br />
    # <% end %>
    #
    # There is also a walk_tree instance method that starts walking from
    # the node it is called on.
    #
    def walk_tree options = {}, &block
      algorithm = options.fetch :algorithm, :dfs
      where = options.fetch :where, {}
      send("walk_tree_#{algorithm}", where, &block)
    end

    def self.extended mod
      mod.class_eval do
        def walk_tree options = {}, &block
          algorithm = options.fetch :algorithm, :dfs
          where = options.fetch :where, {}
          self.class.send("walk_tree_#{algorithm}", where, self, &block)
        end
      end
    end

    private

    def walk_tree_bfs where = {}, node = nil, level = -1, &block
      nodes = (node.nil? ? roots : node.children).where(where)
      nodes.each{|child| yield(child, level + 1)}
      nodes.each{|child| walk_tree_bfs where, child, level + 1, &block}
    end

    def walk_tree_dfs where = {}, node = nil, level = -1, &block
      yield(node, level) unless level == -1
      nodes = (node.nil? ? roots : node.children).where(where)
      nodes.each{|child| walk_tree_dfs where, child, level + 1, &block}
    end
  end
end
